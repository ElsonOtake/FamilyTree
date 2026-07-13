# frozen_string_literal: true

require 'stringio'

module Pedigree
  # Renders a descendant tree to a PDF (binary string) in the classic genealogy
  # style: circular portraits (avatar or silhouette), name + birth/death years
  # below, spouses joined by a marriage line, children bracketed underneath, on
  # a parchment background watermarked with the app logo, under a title.
  class Pdf
    PARCHMENT = 'efece2'
    LINE_COLOR = '6b6b57'
    FRAME_COLOR = '8a7b46'
    NAME_COLOR = '2b2b2b'
    YEAR_COLOR = '6b6b6b'
    TITLE_COLOR = '5c3350'
    LOGO_PATH = Rails.root.join('app/assets/images/EAO.png')

    def initialize(root_person, generations: Chart::DEFAULT_GENERATIONS)
      @root_person = root_person
      @generations = generations
    end

    def render
      node = Chart.new(@root_person, generations: @generations).build
      @layout = Layout.new(node).call
      @offset_x = Geom::MARGIN - @layout.min_x

      Prawn::Document.new(page_size: [page_width, page_height], margin: 0).tap do |pdf|
        pdf.font 'Times-Roman'
        draw_background(pdf)
        draw_title(pdf)
        draw_node(pdf, @layout.root) if @layout.root
      end.render
    end

    private

    # --- page geometry ---------------------------------------------------------

    def page_width
      (@layout.max_x - @layout.min_x) + 2 * Geom::MARGIN
    end

    def page_height
      2 * Geom::MARGIN + Geom::TITLE_H +
        @layout.generations * (Geom::PORTRAIT_D + Geom::LABEL_H) +
        (@layout.generations - 1) * Geom::ROW_GAP
    end

    def x_at(px)
      px + @offset_x
    end

    # Top-down y of a generation's portrait top edge.
    def row_top(generation)
      Geom::MARGIN + Geom::TITLE_H + (generation - 1) * Geom::ROW_STEP
    end

    # Prawn's origin is bottom-left; convert a top-down y.
    def flip(top_down_y)
      page_height - top_down_y
    end

    # --- drawing ---------------------------------------------------------------

    def draw_background(pdf)
      pdf.fill_color PARCHMENT
      pdf.fill_rectangle([0, page_height], page_width, page_height)

      size = [page_height * 0.6, page_width * 0.45].min
      pdf.transparent(0.07) do
        pdf.image(LOGO_PATH.to_s, fit: [size, size],
                                  at: [(page_width - size) / 2.0, (page_height + size) / 2.0])
      end
    rescue StandardError
      nil
    end

    def draw_title(pdf)
      pdf.fill_color TITLE_COLOR
      pdf.font('Times-Bold') do
        pdf.text_box(safe(title_text), at: [Geom::MARGIN, page_height - Geom::MARGIN / 2.0],
                                       width: page_width - 2 * Geom::MARGIN, height: Geom::TITLE_H,
                                       size: 18, align: :center, overflow: :shrink_to_fit)
      end
    end

    def title_text
      I18n.t('people.show.pedigree_title', name: @root_person.name)
    end

    def draw_node(pdf, placed)
      placed.marriages.each do |union|
        draw_marriage_line(pdf, placed, union)
        draw_children_links(pdf, placed, union)
      end
      placed.portraits.each { |slot| draw_portrait(pdf, slot, placed.generation) }
      placed.marriages.each { |union| union.children.each { |child| draw_node(pdf, child) } }
    end

    def draw_marriage_line(pdf, placed, union)
      return unless union.spouse_center

      y = flip(row_top(placed.generation) + Geom::PORTRAIT_D / 2.0)
      stroke(pdf) { pdf.stroke_line([x_at(placed.person_center), y], [x_at(union.spouse_center), y]) }
    end

    def draw_children_links(pdf, placed, union)
      return if union.children.empty?

      gen = placed.generation
      stem_top = placed.marriages.one? ? row_top(gen) + Geom::PORTRAIT_D / 2.0
                                       : row_top(gen) + Geom::PORTRAIT_D + Geom::LABEL_H
      child_top = row_top(gen + 1)
      bracket = child_top - Geom::ROW_GAP / 2.0
      stem_x = x_at(union.descent_x)
      child_xs = union.children.map { |c| x_at(c.person_center) }

      stroke(pdf) do
        pdf.stroke_line([stem_x, flip(stem_top)], [stem_x, flip(bracket)])
        pdf.stroke_line([child_xs.min, flip(bracket)], [child_xs.max, flip(bracket)])
        child_xs.each { |cx| pdf.stroke_line([cx, flip(bracket)], [cx, flip(child_top)]) }
      end
    end

    def draw_portrait(pdf, slot, generation)
      diameter = Geom::PORTRAIT_D
      center_x = x_at(slot.x) + Geom::CELL_W / 2.0
      top = flip(row_top(generation))
      center_y = top - diameter / 2.0

      data = Pedigree::Portrait.data_for(slot.person)
      pdf.image(StringIO.new(data), at: [center_x - diameter / 2.0, top], fit: [diameter, diameter])

      pdf.stroke_color FRAME_COLOR
      pdf.line_width 1.2
      pdf.stroke_circle([center_x, center_y], diameter / 2.0)
      pdf.stroke_circle([center_x, center_y], diameter / 2.0 + 2)

      draw_label(pdf, slot.person, center_x, row_top(generation) + diameter)
    end

    def draw_label(pdf, person, center_x, portrait_bottom)
      width = Geom::CELL_W + Geom::SPOUSE_GAP - 8
      left = center_x - width / 2.0
      name_top = portrait_bottom + Geom::NAME_GAP

      pdf.fill_color NAME_COLOR
      pdf.font('Times-Bold') do
        pdf.text_box(safe(person.name), at: [left, flip(name_top)], width: width, height: 22,
                                        size: 7, align: :center, overflow: :shrink_to_fit, leading: 0.5)
      end

      years = years_line(person)
      return if years.blank?

      pdf.fill_color YEAR_COLOR
      pdf.font('Times-Roman') do
        pdf.text_box(years, at: [left, flip(name_top + 22)], width: width, height: 12,
                            size: 6.5, align: :center)
      end
    end

    def years_line(person)
      birth = person.birth_year || person.birth&.year
      death = person.death_year || person.death&.year
      return "#{birth} – #{death}" if birth && death
      return birth.to_s if birth
      return "– #{death}" if death

      ''
    end

    def stroke(pdf)
      pdf.stroke_color LINE_COLOR
      pdf.line_width 0.9
      yield
    end

    # Built-in AFM fonts only handle WinAnsi; sanitize so an unusual glyph can't
    # crash rendering.
    def safe(text)
      text.to_s.encode('Windows-1252', invalid: :replace, undef: :replace, replace: '?').encode('UTF-8')
    end
  end
end
