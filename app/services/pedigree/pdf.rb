# frozen_string_literal: true

module Pedigree
  # Renders a descendant tree to a PDF (binary string) in the classic genealogy
  # style: oval portraits, name + birth/death years below, spouses joined by a
  # marriage line, children bracketed underneath. The framed-heirloom page
  # dressing and the portraits/labels come from Pedigree::Chrome; this class adds
  # the top-down generation flow and the marriage/children connectors.
  class Pdf
    include Chrome

    def initialize(root_person, generations: Chart::DEFAULT_GENERATIONS, include_pets: true)
      @root_person = root_person
      @generations = generations
      @include_pets = include_pets
    end

    def render
      node = build_root_node
      @layout = Layout.new(node).call
      @offset_x = Geom::MARGIN - @layout.min_x

      Prawn::Document.new(page_size: [page_width, page_height], margin: 0).tap do |pdf|
        pdf.font 'Times-Roman'
        draw_background(pdf)
        draw_frame(pdf)
        draw_title(pdf)
        draw_node(pdf, @layout.root) if @layout.root
        draw_footer(pdf)
      end.render
    end

    private

    # The tree to render. Overridden by subclasses (e.g. the descendants-only
    # chart) to swap in a different generation walk.
    def build_root_node
      Chart.new(@root_person, generations: @generations, include_pets: @include_pets).build
    end

    # Top-down y of a generation's portrait top edge: generation 1 at the top,
    # descendants flowing downward.
    def row_top(generation)
      Geom::MARGIN + Geom::TITLE_H + Geom::TITLE_GAP + (generation - 1) * Geom::ROW_STEP
    end

    def title_text
      I18n.t('people.show.descendants_full_title', name: @root_person.name)
    end

    def draw_links(pdf, placed, union)
      draw_marriage_line(pdf, placed, union)
      draw_children_links(pdf, placed, union)
    end

    def draw_marriage_line(pdf, placed, union)
      return unless union.spouse_center

      y = flip(row_top(placed.generation) + Geom::PORTRAIT_H / 2.0)
      stroke(pdf) { pdf.stroke_line([x_at(placed.person_center), y], [x_at(union.spouse_center), y]) }
    end

    def draw_children_links(pdf, placed, union)
      return if union.children.empty?

      gen = placed.generation
      # Drop the stem from the marriage line, at the midpoint between the couple,
      # so each marriage's children hang from that couple's own line.
      stem_top = row_top(gen) + Geom::PORTRAIT_H / 2.0
      child_top = row_top(gen + 1)
      bracket = child_top - Geom::ROW_GAP / 2.0
      stem_x = x_at(descent_x(placed, union))
      child_xs = union.children.map { |c| x_at(c.person_center) }

      stroke(pdf) do
        pdf.stroke_line([stem_x, flip(stem_top)], [stem_x, flip(bracket)])
        pdf.stroke_line([[child_xs.min, stem_x].min, flip(bracket)], [[child_xs.max, stem_x].max, flip(bracket)])
        child_xs.each { |cx| pdf.stroke_line([cx, flip(bracket)], [cx, flip(child_top)]) }
      end
    end

    # The x the children descend from: the midpoint of the couple's marriage line
    # when there is a spouse, otherwise the children's own centre (single parent).
    def descent_x(placed, union)
      return union.descent_x unless union.spouse_center

      (placed.person_center + union.spouse_center) / 2.0
    end
  end
end
