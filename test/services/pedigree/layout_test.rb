# frozen_string_literal: true

require 'test_helper'

module Pedigree
  class LayoutTest < ActiveSupport::TestCase
    def person(name)
      Person.new(name: name)
    end

    def node(name, generation, marriages: [])
      Chart::Node.new(person: person(name), marriages: marriages, generation: generation)
    end

    def marriage(spouse_name = nil, children: [])
      Chart::Marriage.new(spouse: spouse_name && person(spouse_name), children: children)
    end

    test 'places a single childless person' do
      result = Layout.new(node('solo', 1)).call

      assert_equal 1, result.generations
      assert_equal 1, result.root.portraits.size
      assert(result.root.marriages.all? { |m| m.children.empty? })
    end

    test 'places a couple as two portraits' do
      result = Layout.new(node('root', 1, marriages: [marriage('spouse')])).call

      assert_equal 2, result.root.portraits.size
    end

    test 'keeps each marriage children under their own couple' do
      m1 = marriage('sp1', children: [node('a', 2), node('b', 2)])
      m2 = marriage('sp2', children: [node('c', 2)])
      result = Layout.new(node('root', 1, marriages: [m1, m2])).call

      unions = result.root.marriages
      assert_equal [2, 1], unions.map { |u| u.children.size }
      # the two marriages drop their children at different x positions
      assert_not_equal unions.first.descent_x, unions.last.descent_x
      assert_equal 2, result.generations
    end

    test 'does not overlap a wide couple centered over a single child' do
      # couple (2 portraits) over one child: the child gets its own slot, the
      # couple centers over it, and nothing shares an x coordinate.
      result = Layout.new(node('root', 1, marriages: [marriage('spouse', children: [node('kid', 2)])])).call

      xs = result.root.portraits.map(&:x)
      assert_equal xs.uniq.size, xs.size
    end
  end
end
