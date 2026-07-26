# frozen_string_literal: true

module Pedigree
  module Descendants
    # Renders the descendants-only tree to a PDF: the focal person at the top,
    # children below, grandchildren below them, and so on with no generation
    # limit and no spouses. Reuses the descendant Pedigree::Pdf drawing wholesale
    # — a spouseless node draws no marriage line and its children hang from the
    # person's own centre — swapping only the tree source and the title.
    class Pdf < Pedigree::Pdf
      private

      def build_root_node
        Descendants::Chart.new(@root_person, include_pets: @include_pets).build
      end

      def title_text
        I18n.t('people.show.descendants_title', name: @root_person.name)
      end
    end
  end
end
