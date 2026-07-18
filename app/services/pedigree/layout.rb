# frozen_string_literal: true

module Pedigree
  # Positions a descendant tree in top-down point coordinates using two passes:
  # measure each subtree's full extent, then place subtrees side by side so
  # nothing overlaps. A person's marriages are laid out as separate slots — each
  # wide enough for its own children — so multiple marriages never collide and
  # every child stays under the right couple.
  #
  # For a single marriage the couple is centred over its children's anchor (the
  # midpoint of the children's person portraits). Because a child that is itself
  # a couple sits left-of-centre inside its own slot, that anchor can fall away
  # from the slot centre and push the parent couple sideways. Each node therefore
  # tracks two things during the measure pass: its full @width and the @anchor —
  # the offset of the person portrait from the node's left edge — so a parent can
  # reserve the overhang a couple needs and never overlap a neighbour.
  class Layout
    SLOT_GAP = 34 # gap between a person and a marriage slot (and between slots)

    Slot = Struct.new(:person, :x, keyword_init: true) # x = portrait left edge
    Union = Struct.new(:spouse_center, :descent_x, :children, keyword_init: true)
    Placed = Struct.new(:portraits, :person_center, :marriages, :generation, keyword_init: true)
    Result = Struct.new(:root, :min_x, :max_x, :generations, keyword_init: true)

    # Offset from a couple's centre to the person (or the spouse) portrait centre.
    SPOUSE_OFFSET = (Geom::CELL_W + Geom::SPOUSE_GAP) / 2.0

    def initialize(root_node)
      @root = root_node
      @width = {}.compare_by_identity   # full horizontal extent of the subtree
      @anchor = {}.compare_by_identity  # person portrait centre, offset from left
      @shift = {}.compare_by_identity   # children left edge, offset from left
      @min_x = Float::INFINITY
      @max_x = -Float::INFINITY
      @generations = 1
    end

    def call
      return Result.new(root: nil, min_x: 0, max_x: Geom::CELL_W, generations: 1) unless @root

      measure(@root)
      Result.new(root: assign(@root, Geom::MARGIN), min_x: @min_x, max_x: @max_x, generations: @generations)
    end

    private

    # --- pass 1: widths + anchors ----------------------------------------------

    def measure(node)
      return if @width.key?(node)

      if node.marriages.empty?
        @width[node] = Geom::CELL_W.to_f
        @anchor[node] = Geom::CELL_W / 2.0
      elsif node.marriages.one?
        measure_one(node)
      else
        measure_many(node)
      end
    end

    # A single marriage: the couple is centred over the children's anchor, so the
    # node must reserve whatever the couple overhangs beyond the children group.
    def measure_one(node)
      marriage = node.marriages.first
      spouse = marriage.spouse

      if marriage.children.any?
        anchor, group = children_anchor(marriage.children)
        half = spouse ? pair_width / 2.0 : Geom::CELL_W / 2.0
        ext_left = [0.0, anchor - half].min
        ext_right = [group, anchor + half].max
        @width[node]  = ext_right - ext_left
        @shift[node]  = -ext_left
        @anchor[node] = @shift[node] + anchor - (spouse ? SPOUSE_OFFSET : 0.0)
      else
        @width[node]  = spouse ? pair_width : Geom::CELL_W.to_f
        @anchor[node] = Geom::CELL_W / 2.0
      end
    end

    # Multiple marriages: person plus one slot per marriage, laid out side by
    # side. Each slot centres its spouse and children within itself, so nothing
    # overhangs and the node width already contains everything.
    def measure_many(node)
      widths = slot_widths(node)
      @width[node] = widths.sum + Geom::CELL_W + node.marriages.size * SLOT_GAP
      @anchor[node] =
        if node.marriages.size == 2 # arrangement is [slot0, person, slot1]
          widths[0] + SLOT_GAP + Geom::CELL_W / 2.0
        else # arrangement is [person, slot0, slot1, ...]
          Geom::CELL_W / 2.0
        end
    end

    def slot_widths(node)
      node.marriages.map { |m| [group_width(m.children), Geom::CELL_W].max }
    end

    def group_width(children)
      return 0 if children.empty?

      children.each { |c| measure(c) }
      children.sum { |c| @width[c] } + (children.size - 1) * Geom::SIBLING_GAP
    end

    # Anchor (midpoint of the children's person portraits) and total width of a
    # children group, measured in coordinates local to the group's left edge.
    def children_anchor(children)
      cursor = 0.0
      centers = children.map do |child|
        measure(child)
        person = cursor + @anchor[child]
        cursor += @width[child] + Geom::SIBLING_GAP
        person
      end
      [(centers.first + centers.last) / 2.0, cursor - Geom::SIBLING_GAP]
    end

    def pair_width
      2 * Geom::CELL_W + Geom::SPOUSE_GAP
    end

    # --- pass 2: placement -----------------------------------------------------

    def assign(node, left)
      placed =
        if node.marriages.empty? then place_single(node, left)
        elsif node.marriages.one? then place_one_marriage(node, left)
        else place_many_marriages(node, left)
        end
      record_extent(placed)
      placed
    end

    def place_single(node, left)
      center = left + @width[node] / 2.0
      build(node, center, [Slot.new(person: node.person, x: center - Geom::CELL_W / 2.0)], [])
    end

    def place_one_marriage(node, left)
      marriage = node.marriages.first
      spouse = marriage.spouse

      if marriage.children.any?
        kids = place_children(marriage.children, left + @shift[node])
        center = child_center(kids)
        person_center = spouse ? center - SPOUSE_OFFSET : center
        spouse_center = center + SPOUSE_OFFSET
        descent = center
      else
        kids = []
        person_center = left + Geom::CELL_W / 2.0
        spouse_center = left + pair_width - Geom::CELL_W / 2.0
        descent = nil
      end

      slots = portrait_slots(node.person, person_center, [[spouse, spouse_center]])
      union = Union.new(spouse_center: spouse && spouse_center, descent_x: descent, children: kids)
      build(node, person_center, slots, [union])
    end

    def place_many_marriages(node, left)
      widths = slot_widths(node)
      elements = arrangement(node, widths)
      total = elements.sum { |e| e[:w] } + (elements.size - 1) * SLOT_GAP
      cursor = left + (@width[node] - total) / 2.0

      person_center = nil
      spouse_centers = {}
      unions = {}
      elements.each do |element|
        center = cursor + element[:w] / 2.0
        if element[:person]
          person_center = center
        else
          spouse_centers[element[:index]], unions[element[:index]] = place_slot(element, cursor, center)
        end
        cursor += element[:w] + SLOT_GAP
      end

      finish_many(node, person_center, spouse_centers, unions)
    end

    # [slot0, person, slot1] for two marriages; [person, slot0, slot1, ...] otherwise.
    def arrangement(node, widths)
      slots = node.marriages.each_index.map { |i| { w: widths[i], index: i, marriage: node.marriages[i] } }
      person = { w: Geom::CELL_W, person: true }
      node.marriages.size == 2 ? [slots[0], person, slots[1]] : [person, *slots]
    end

    def place_slot(element, left, center)
      children = element[:marriage].children
      if children.any?
        kids = place_children(children, left + (element[:w] - group_width(children)) / 2.0)
        [center, Union.new(spouse_center: center, descent_x: child_center(kids), children: kids)]
      else
        [center, Union.new(spouse_center: center, descent_x: nil, children: [])]
      end
    end

    def finish_many(node, person_center, spouse_centers, unions)
      pairs = node.marriages.each_index.map { |i| [node.marriages[i].spouse, spouse_centers[i]] }
      slots = portrait_slots(node.person, person_center, pairs)
      marriages = node.marriages.each_index.map do |i|
        unions[i] || Union.new(spouse_center: spouse_centers[i], descent_x: nil, children: [])
      end
      build(node, person_center, slots, marriages)
    end

    # --- helpers ---------------------------------------------------------------

    def place_children(children, left)
      cursor = left
      children.map do |child|
        placed = assign(child, cursor)
        cursor += @width[child] + Geom::SIBLING_GAP
        placed
      end
    end

    def child_center(children)
      (children.first.person_center + children.last.person_center) / 2.0
    end

    def portrait_slots(person, person_center, spouse_pairs)
      slots = [Slot.new(person: person, x: person_center - Geom::CELL_W / 2.0)]
      spouse_pairs.each do |spouse, center|
        slots << Slot.new(person: spouse, x: center - Geom::CELL_W / 2.0) if spouse && center
      end
      slots
    end

    def build(node, person_center, portraits, marriages)
      Placed.new(portraits: portraits, person_center: person_center,
                 marriages: marriages, generation: node.generation)
    end

    def record_extent(placed)
      placed.portraits.each do |slot|
        @min_x = [@min_x, slot.x].min
        @max_x = [@max_x, slot.x + Geom::CELL_W].max
      end
      @generations = [@generations, placed.generation].max
    end
  end
end
