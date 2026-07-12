# frozen_string_literal: true

module Pedigree
  # Assigns grid coordinates to a descendant tree. Each leaf takes the next
  # integer column left-to-right; each parent is centered over its children.
  # Rows come from the generation. Produces positioned boxes plus parent->child
  # edges for the connector lines, and the total column count for sizing.
  class Layout
    Box = Struct.new(:person, :generation, :col, keyword_init: true)

    Result = Struct.new(:boxes, :edges, :columns, :generations, keyword_init: true)

    def initialize(root_node)
      @root = root_node
      @boxes = []
      @edges = []
      @next_leaf = 0
    end

    def call
      place(@root) if @root
      Result.new(
        boxes: @boxes,
        edges: @edges,
        columns: [@next_leaf, 1].max,
        generations: @boxes.map(&:generation).max || 1
      )
    end

    private

    # Places a node and its subtree, returning the node's Box.
    def place(node)
      box = Box.new(person: node.person, generation: node.generation, col: nil)

      if node.leaf?
        box.col = @next_leaf
        @next_leaf += 1
      else
        child_boxes = node.children.map { |child| place(child) }
        box.col = (child_boxes.first.col + child_boxes.last.col) / 2.0
        child_boxes.each { |child_box| @edges << [box, child_box] }
      end

      @boxes << box
      box
    end
  end
end
