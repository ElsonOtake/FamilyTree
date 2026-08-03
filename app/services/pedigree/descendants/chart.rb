# frozen_string_literal: true

module Pedigree
  module Descendants
    # Builds a descendants-only tree for a focal person: their children,
    # grandchildren and so on, with no generation limit and no spouses shown.
    # Reuses the descendant Chart's Node/Marriage structs, but emits a single
    # spouseless marriage per person (spouse: nil) whose children merge every
    # child the person had across all of their couples — so the shared Layout
    # and PDF render the person plus their descendants with no marriage lines.
    #
    # Soft-deleted people are excluded (paranoia scope) and a visited-set keeps
    # the walk cycle-safe (and collapses anyone reached by two paths).
    class Chart
      Node = Pedigree::Chart::Node
      Marriage = Pedigree::Chart::Marriage

      def initialize(root, include_pets: true)
        @root = root
        @include_pets = include_pets
        @seen = Set.new
      end

      def build
        build_node(@root, 1)
      end

      private

      def build_node(person, generation)
        return nil if person.nil? || @seen.include?(person.id)

        @seen << person.id
        Node.new(person: person, generation: generation, marriages: child_marriage(person, generation))
      end

      # Every child across all of the person's couples, merged into one spouseless
      # marriage. Nil when the person has no recorded children.
      def child_marriage(person, generation)
        children = child_people(person).map { |child| build_node(child, generation + 1) }.compact
        return [] if children.empty?

        [Marriage.new(spouse: nil, children: children)]
      end

      # All children across the person's couples, merged and ordered oldest-first
      # (see BirthOrder). Pets ('P' gender) are dropped unless opted in.
      def child_people(person)
        people = Couple.where('person1_id = :id OR person2_id = :id', id: person.id).flat_map(&:people)
        people = people.reject(&:pet?) unless @include_pets
        BirthOrder.sort(people)
      end
    end
  end
end
