# frozen_string_literal: true

module Pedigree
  module Ancestors
    # Builds an ancestor tree for a focal person: their parents, grandparents and
    # so on, with no generation limit. Reuses the descendant Chart's Node/Marriage
    # structs by modelling a person's parents as its "children" (spouse: nil), so
    # the shared Layout positions the focal person centred under their parents.
    #
    # Only the first parent couple is followed (matching Person#father/#mother).
    # Soft-deleted people are excluded (paranoia scope) and a visited-set keeps the
    # walk cycle-safe (and collapses any ancestor reached by two paths).
    class Chart
      Node = Pedigree::Chart::Node
      Marriage = Pedigree::Chart::Marriage

      def initialize(root)
        @root = root
        @seen = Set.new
      end

      def build
        build_node(@root, 1)
      end

      private

      def build_node(person, generation)
        return nil if person.nil? || @seen.include?(person.id)

        @seen << person.id
        Node.new(person: person, generation: generation, marriages: parent_marriages(person, generation))
      end

      def parent_marriages(person, generation)
        couple = person.couples.first
        return [] unless couple

        parents = ordered_parents(couple).map { |parent| build_node(parent, generation + 1) }.compact
        return [] if parents.empty?

        [Marriage.new(spouse: nil, children: parents)]
      end

      # Father (male) on the left, mother on the right; otherwise keep person1/2.
      def ordered_parents(couple)
        pair = [couple.person1, couple.person2].compact
        pair.reverse! if pair.size == 2 && pair.last.gender == 'M' && pair.first.gender != 'M'
        pair
      end
    end
  end
end
