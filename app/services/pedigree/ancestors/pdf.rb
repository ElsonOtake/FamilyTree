# frozen_string_literal: true

module Pedigree
  module Ancestors
    # Renders an ancestor tree to a PDF (binary string): the focal person at the
    # bottom, parents above, grandparents above them, and so on. Shares the
    # framed-heirloom dressing and the oval portraits with the descendant chart
    # via Pedigree::Chrome; here the generation flow is inverted (generation 1 at
    # the bottom) and each person links up to their parents with an upward bracket.
    class Pdf
      include Chrome

      def initialize(root_person, include_pets: true)
        @root_person = root_person
        @include_pets = include_pets
      end

      def render
        node = Ancestors::Chart.new(@root_person, include_pets: @include_pets).build
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

      # Top-down y of a generation's portrait top edge: generation 1 (focal) at
      # the bottom, ancestors rising toward the top.
      def row_top(generation)
        Geom::MARGIN + Geom::TITLE_H + Geom::TITLE_GAP +
          (@layout.generations - generation) * Geom::ROW_STEP
      end

      def title_text
        I18n.t('people.show.ancestor_title', name: @root_person.name)
      end

      # A person's parents sit in the row above, joined by a marriage line at their
      # portrait mid-height (the mirror of the descendant couple line). The person
      # rises to that line's midpoint — the empty space between the two portraits —
      # so the connector never crosses a name. The person is centred under the
      # parents' midpoint, so its up-stem meets the marriage line exactly centre.
      def draw_links(pdf, placed, union)
        return if union.children.empty?

        gen = placed.generation
        parent_mid = row_top(gen + 1) + Geom::PORTRAIT_H / 2.0
        stem_x = x_at(placed.person_center)
        parent_xs = union.children.map { |c| x_at(c.person_center) }

        stroke(pdf) do
          pdf.stroke_line([parent_xs.min, flip(parent_mid)], [parent_xs.max, flip(parent_mid)]) if parent_xs.size > 1
          pdf.stroke_line([stem_x, flip(row_top(gen))], [stem_x, flip(parent_mid)])
        end
      end
    end
  end
end
