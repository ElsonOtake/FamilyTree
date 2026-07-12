# frozen_string_literal: true

module Pedigree
  # Builds a descendant tree for a focal person, up to `generations` levels
  # (the focal person is generation 1). Children are gathered across all of a
  # person's couples via Person#children. Soft-deleted people are excluded by
  # the default paranoia scope, and a visited-set makes the walk cycle-safe.
  class Chart
    Node = Struct.new(:person, :generation, :children, keyword_init: true) do
      def leaf?
        children.empty?
      end
    end

    DEFAULT_GENERATIONS = 5

    def initialize(root, generations: DEFAULT_GENERATIONS)
      @root = root
      @generations = generations
      @seen = Set.new
    end

    # Returns the root Node, or nil when the root person is missing.
    def build
      build_node(@root, 1)
    end

    private

    def build_node(person, generation)
      return nil if person.nil? || @seen.include?(person.id)

      @seen << person.id
      children = descend?(generation) ? child_nodes(person, generation) : []
      Node.new(person: person, generation: generation, children: children)
    end

    def child_nodes(person, generation)
      person.children.map { |child| build_node(child, generation + 1) }.compact
    end

    def descend?(generation)
      generation < @generations
    end
  end
end
