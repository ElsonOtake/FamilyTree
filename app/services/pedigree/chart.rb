# frozen_string_literal: true

module Pedigree
  # Builds a descendant tree for a focal person, up to `generations` levels
  # (the focal person is generation 1). Each node is a descendant plus one entry
  # per marriage (couple), each carrying that couple's spouse and the children
  # born to it — so children stay linked to the right parents when a person has
  # more than one marriage. Soft-deleted people are excluded (paranoia scope)
  # and a visited-set keeps the walk cycle-safe.
  class Chart
    Marriage = Struct.new(:spouse, :children, keyword_init: true)

    Node = Struct.new(:person, :marriages, :generation, keyword_init: true) do
      def spouses
        marriages.map(&:spouse).compact
      end

      def people
        [person, *spouses]
      end

      def childless?
        marriages.all? { |m| m.children.empty? }
      end
    end

    DEFAULT_GENERATIONS = 5

    def initialize(root, generations: DEFAULT_GENERATIONS)
      @root = root
      @generations = generations
      @seen = Set.new
    end

    def build
      build_node(@root, 1)
    end

    private

    def build_node(person, generation)
      return nil if person.nil? || @seen.include?(person.id)

      @seen << person.id
      Node.new(person: person, generation: generation, marriages: marriages_for(person, generation))
    end

    def marriages_for(person, generation)
      couples_of(person).map do |couple|
        spouse = couple.person1_id == person.id ? couple.person2 : couple.person1
        children = descend?(generation) ? child_nodes(couple, generation) : []
        Marriage.new(spouse: spouse, children: children)
      end
    end

    def couples_of(person)
      Couple.where('person1_id = :id OR person2_id = :id', id: person.id)
            .includes(:person1, :person2).order(:marriage, :id)
    end

    def child_nodes(couple, generation)
      couple.people.map { |child| build_node(child, generation + 1) }.compact
    end

    def descend?(generation)
      generation < @generations
    end
  end
end
