# frozen_string_literal: true

module Pedigree
  # Renders a descendant tree to a PDF (binary string) with Prawn: one rounded
  # box per person, connected to their children by elbow lines. The page is
  # sized to fit the whole tree so nothing is clipped.
  class Pdf
    BOX_W = 150
    BOX_H = 46
    H_GAP = 24
    V_GAP = 64
    MARGIN = 32
    RADIUS = 5

    FOCAL_FILL = '8A4D76'
    BOX_FILL = 'FFFFFF'
    BOX_STROKE = '94A3B8'
    LINE_COLOR = 'CBD5E1'

    def initialize(root_person, generations: Chart::DEFAULT_GENERATIONS)
      @root_person = root_person
      @generations = generations
    end

    def render
      node = Chart.new(@root_person, generations: @generations).build
      @layout = Layout.new(node).call

      Prawn::Document.new(page_size: [page_width, page_height], margin: 0).tap do |pdf|
        draw_edges(pdf)
        draw_boxes(pdf)
      end.render
    end

    private

    def page_width
      MARGIN * 2 + @layout.columns * BOX_W + (@layout.columns - 1) * H_GAP
    end

    def page_height
      MARGIN * 2 + @layout.generations * BOX_H + (@layout.generations - 1) * V_GAP
    end

    def box_left(col)
      MARGIN + col * (BOX_W + H_GAP)
    end

    # Top edge of a box (Prawn y grows upward, so generation 1 sits highest).
    def box_top(generation)
      page_height - (MARGIN + (generation - 1) * (BOX_H + V_GAP))
    end

    def draw_edges(pdf)
      pdf.stroke_color LINE_COLOR
      pdf.line_width 0.75
      @layout.edges.each do |parent, child|
        parent_x = box_left(parent.col) + BOX_W / 2.0
        child_x = box_left(child.col) + BOX_W / 2.0
        parent_bottom = box_top(parent.generation) - BOX_H
        child_top = box_top(child.generation)
        mid_y = (parent_bottom + child_top) / 2.0

        pdf.stroke do
          pdf.move_to(parent_x, parent_bottom)
          pdf.line_to(parent_x, mid_y)
          pdf.line_to(child_x, mid_y)
          pdf.line_to(child_x, child_top)
        end
      end
    end

    def draw_boxes(pdf)
      @layout.boxes.each { |box| draw_box(pdf, box) }
    end

    def draw_box(pdf, box)
      focal = box.generation == 1
      left = box_left(box.col)
      top = box_top(box.generation)

      pdf.fill_color(focal ? FOCAL_FILL : BOX_FILL)
      pdf.stroke_color BOX_STROKE
      pdf.line_width 0.75
      pdf.fill_and_stroke { pdf.rounded_rectangle([left, top], BOX_W, BOX_H, RADIUS) }

      pdf.fill_color(focal ? 'FFFFFF' : '1E293B')
      pdf.text_box(safe(box.person.name), at: [left + 6, top - 6], width: BOX_W - 12, height: 18,
                                          size: 9, style: :bold, overflow: :shrink_to_fit)

      dates = dates_line(box.person)
      return if dates.blank?

      pdf.fill_color(focal ? 'F1E7EE' : '64748B')
      pdf.text_box(safe(dates), at: [left + 6, top - 26], width: BOX_W - 12, height: 14,
                                size: 7, overflow: :shrink_to_fit)
    end

    def dates_line(person)
      [person.birth_date_formatted.presence, person.death_date_formatted.presence].compact.join(' – ')
    end

    # The built-in AFM font only handles WinAnsi (Windows-1252). Names are
    # romaji, but replace any character outside that set so an unusual glyph
    # (e.g. stray kanji) can't crash rendering.
    def safe(text)
      text.to_s.encode('Windows-1252', invalid: :replace, undef: :replace, replace: '?').encode('UTF-8')
    end
  end
end
