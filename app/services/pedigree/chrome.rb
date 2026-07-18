# frozen_string_literal: true

require 'stringio'

module Pedigree
  # Shared drawing for the pedigree PDFs (descendant and ancestor charts): the
  # framed-heirloom page dressing plus the portraits and labels that both charts
  # render identically. Direction-specific bits — the generation-to-row mapping
  # (`row_top`), the connector style (`draw_links`) and the `title_text` — are
  # supplied by the including class.
  #
  # Constants resolve lexically from this module, so they work unchanged when the
  # module is mixed into a PDF class; the `row_top`/`draw_links`/`title_text`
  # hooks dispatch dynamically to the including class.
  module Chrome
    PARCHMENT   = 'efece2'
    LINE_COLOR  = '6b6b57'
    NAME_COLOR  = '2b2b2b'
    YEAR_COLOR  = '6b6b6b'

    OVAL_FRAME  = '55562e' # olive portrait ring
    MAT_COLOR   = 'f8f5ec' # cream mat behind a portrait

    FRAME_DARK  = '3a1c18' # picture-frame hairlines
    FRAME_WOOD  = '6e352c' # mahogany band
    FRAME_HILIT = 'b6897a' # bevel highlight on the wood
    FRAME_LINER = 'd8d3c4' # light inner liner

    TITLE_FILL  = 'fbfaf6'
    TITLE_EDGE  = 'a9a49a'
    TITLE_COLOR = '4c4b2f'

    LOGO_PATH = Rails.root.join('app/assets/images/EAO.png')
    WATERMARK_PATH = Rails.root.join('app/assets/images/tree_watermark.png')
    WATERMARK_OPACITY = 0.16

    private

    # --- page geometry ---------------------------------------------------------

    def page_width
      (@layout.max_x - @layout.min_x) + 2 * Geom::MARGIN
    end

    def page_height
      2 * Geom::MARGIN + Geom::TITLE_H + Geom::TITLE_GAP + Geom::FOOTER_H +
        @layout.generations * (Geom::PORTRAIT_H + Geom::LABEL_H) +
        (@layout.generations - 1) * Geom::ROW_GAP
    end

    def x_at(px)
      px + @offset_x
    end

    # Prawn's origin is bottom-left; convert a top-down y.
    def flip(top_down_y)
      page_height - top_down_y
    end

    # --- background & frame ----------------------------------------------------

    def draw_background(pdf)
      pdf.fill_color PARCHMENT
      pdf.fill_rectangle([0, page_height], page_width, page_height)
      draw_watermark(pdf)
    end

    # A single faint tree centred behind the chart, like an heirloom watermark.
    def draw_watermark(pdf)
      avail_w = page_width - 2 * Geom::MARGIN
      avail_h = page_height - Geom::TITLE_H - Geom::FOOTER_H - 2 * Geom::MARGIN
      size = [[avail_h * 0.9, avail_w * 0.6].min, 900].min

      pdf.transparent(WATERMARK_OPACITY) do
        pdf.image(WATERMARK_PATH.to_s, fit: [size, size],
                                       at: [(page_width - size) / 2.0, (page_height + size) / 2.0 - Geom::MARGIN])
      end
    rescue StandardError
      nil
    end

    # A mahogany picture-frame border, drawn as concentric strokes just inside
    # the page edge (within the page margin).
    def draw_frame(pdf)
      frame_rect(pdf, 16, 1.0, FRAME_DARK)  # outer hairline
      frame_rect(pdf, 21, 8.0, FRAME_WOOD)  # mahogany band
      frame_rect(pdf, 18.5, 1.0, FRAME_HILIT) # bevel highlight on the wood
      frame_rect(pdf, 26.5, 1.4, FRAME_LINER) # light liner
      frame_rect(pdf, 29, 0.7, FRAME_DARK)  # inner hairline
    end

    def frame_rect(pdf, inset, line_w, color)
      pdf.stroke_color color
      pdf.line_width line_w
      pdf.stroke_rectangle([inset, page_height - inset], page_width - 2 * inset, page_height - 2 * inset)
    end

    # --- title cartouche -------------------------------------------------------

    def draw_title(pdf)
      text = safe(title_text)
      box_w = [[text.length * 9.5 + 64, 360].max, page_width - 2 * Geom::MARGIN].min
      box_h = Geom::TITLE_H - 14
      box_x = (page_width - box_w) / 2.0
      box_y = flip(Geom::MARGIN + 6) # top edge, in bottom-left coords

      pdf.fill_color TITLE_FILL
      pdf.fill_rounded_rectangle([box_x, box_y], box_w, box_h, 6)
      title_border(pdf, box_x, box_y, box_w, box_h)
      title_corners(pdf, box_x, box_y, box_w, box_h)

      pdf.fill_color TITLE_COLOR
      pdf.font('Times-Bold') do
        pdf.text_box(text, at: [box_x + 12, box_y - (box_h - 18) / 2.0], width: box_w - 24,
                           height: 26, size: 17, align: :center, valign: :center, overflow: :shrink_to_fit)
      end
    end

    def title_border(pdf, x, y, w, h)
      pdf.stroke_color TITLE_EDGE
      pdf.line_width 1.4
      pdf.stroke_rounded_rectangle([x, y], w, h, 6)
      pdf.line_width 0.6
      pdf.stroke_rounded_rectangle([x + 4, y - 4], w - 8, h - 8, 4)
    end

    # Small scroll-like accents at the four inner corners of the cartouche.
    def title_corners(pdf, x, y, w, h)
      pdf.fill_color TITLE_EDGE
      [[x + 9, y - 9], [x + w - 9, y - 9], [x + 9, y - h + 9], [x + w - 9, y - h + 9]].each do |cx, cy|
        pdf.fill { pdf.circle([cx, cy], 2.2) }
      end
    end

    # --- nodes -----------------------------------------------------------------

    # Draw a placed subtree: connectors first (so portraits cover the line ends),
    # then this node's portraits, then recurse. `draw_links` is direction-specific.
    def draw_node(pdf, placed)
      placed.marriages.each { |union| draw_links(pdf, placed, union) }
      placed.portraits.each { |slot| draw_portrait(pdf, slot, placed.generation) }
      placed.marriages.each { |union| union.children.each { |child| draw_node(pdf, child) } }
    end

    # --- oval portrait ---------------------------------------------------------

    def draw_portrait(pdf, slot, generation)
      rx = Geom::PORTRAIT_W / 2.0
      ry = Geom::PORTRAIT_H / 2.0
      center_x = x_at(slot.x) + Geom::CELL_W / 2.0
      top = flip(row_top(generation))
      cy = top - ry

      pdf.fill_color MAT_COLOR
      pdf.fill { pdf.ellipse([center_x, cy], rx + 2.5, ry + 2.5) }

      data = Pedigree::Portrait.data_for(slot.person)
      pdf.image(StringIO.new(data), at: [center_x - rx, top], fit: [Geom::PORTRAIT_W, Geom::PORTRAIT_H])

      pdf.stroke_color OVAL_FRAME
      pdf.line_width 1.6
      pdf.stroke { pdf.ellipse([center_x, cy], rx + 2.5, ry + 2.5) }
      pdf.line_width 0.6
      pdf.stroke { pdf.ellipse([center_x, cy], rx + 0.4, ry + 0.4) }

      portrait_ornaments(pdf, center_x, cy, rx, ry)
      draw_label(pdf, slot.person, center_x, row_top(generation) + Geom::PORTRAIT_H)
    end

    # Tiny beads at the top and bottom of the ring, echoing the scroll motif.
    def portrait_ornaments(pdf, center_x, cy, _rx, ry)
      pdf.fill_color OVAL_FRAME
      [cy + ry + 2.5, cy - ry - 2.5].each { |y| pdf.fill { pdf.circle([center_x, y], 1.5) } }
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

    # --- footer ----------------------------------------------------------------

    def draw_footer(pdf)
      center_x = page_width / 2.0
      logo_w = 46.0
      logo_h = logo_w / 2.0
      logo_top = page_height - Geom::MARGIN - Geom::FOOTER_H + 4

      begin
        pdf.image(LOGO_PATH.to_s, at: [center_x - logo_w / 2.0, flip(logo_top)], fit: [logo_w, logo_h])
      rescue StandardError
        nil
      end

      pdf.fill_color YEAR_COLOR
      pdf.font('Times-Roman') do
        pdf.text_box(safe(footer_text), at: [center_x - 160, flip(logo_top + logo_h + 4)],
                                        width: 320, height: 14, size: 8, align: :center)
      end
    end

    def footer_text
      I18n.t('people.show.pedigree_footer')
    end

    # --- helpers ---------------------------------------------------------------

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
