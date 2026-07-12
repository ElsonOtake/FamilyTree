# frozen_string_literal: true

require 'test_helper'

module Pedigree
  class LayoutTest < ActiveSupport::TestCase
    Node = Chart::Node

    def node(name, generation, children = [])
      Node.new(person: Person.new(name: name), generation: generation, children: children)
    end

    test 'gives leaves distinct integer columns left to right' do
      root = node('root', 1, [node('a', 2), node('b', 2), node('c', 2)])
      result = Layout.new(root).call

      leaves = result.boxes.reject { |b| b.person.name == 'root' }.sort_by(&:col)
      assert_equal [0, 1, 2], leaves.map(&:col)
      assert_equal 3, result.columns
    end

    test 'centers a parent over its children' do
      root = node('root', 1, [node('a', 2), node('b', 2), node('c', 2)])
      result = Layout.new(root).call

      root_box = result.boxes.find { |b| b.person.name == 'root' }
      assert_equal 1.0, root_box.col # midpoint of columns 0 and 2
      assert_equal 1, root_box.generation
    end

    test 'records a parent-child edge for every child' do
      root = node('root', 1, [node('a', 2), node('b', 2)])
      result = Layout.new(root).call

      assert_equal 2, result.edges.size
      result.edges.each { |parent, _child| assert_equal 'root', parent.person.name }
    end

    test 'handles a single childless node' do
      result = Layout.new(node('solo', 1)).call

      assert_equal 1, result.columns
      assert_equal 1, result.generations
      assert_empty result.edges
    end
  end
end
