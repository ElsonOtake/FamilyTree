# frozen_string_literal: true

require 'test_helper'

module Pedigree
  class ChartTest < ActiveSupport::TestCase
    setup do
      @user = User.create!(name: 'Recorder', email: 'rec@example.com',
                           password: 'password123', confirmed_at: Time.current)
      # focal -> child -> grandchild
      @focal = Person.create!(name: 'Focal', gender: 'M')
      @spouse = Person.create!(name: 'Spouse', gender: 'F')
      @couple = Couple.create!(person1: @focal, person2: @spouse)
      @child = Person.create!(name: 'Child', gender: 'M')
      Child.create!(couple: @couple, person: @child, current_user: @user)

      @child_spouse = Person.create!(name: 'Child Spouse', gender: 'F')
      @child_couple = Couple.create!(person1: @child, person2: @child_spouse)
      @grandchild = Person.create!(name: 'Grandchild', gender: 'X')
      Child.create!(couple: @child_couple, person: @grandchild, current_user: @user)
    end

    test 'builds a descendant tree from the focal person' do
      node = Chart.new(@focal, generations: 5).build

      assert_equal @focal, node.person
      assert_equal 1, node.generation
      assert_equal %w[Child], node.children.map { |c| c.person.name }
      assert_equal %w[Grandchild], node.children.first.children.map { |c| c.person.name }
      assert node.children.first.children.first.leaf?
    end

    test 'stops at the generation limit' do
      node = Chart.new(@focal, generations: 2).build

      assert_equal %w[Child], node.children.map { |c| c.person.name }
      assert_empty node.children.first.children, 'generation 3 should not be built'
    end

    test 'excludes soft-deleted descendants' do
      @grandchild.destroy

      node = Chart.new(@focal, generations: 5).build
      assert_empty node.children.first.children
    end

    test 'returns nil for a missing root' do
      assert_nil Chart.new(nil).build
    end

    test 'is cycle-safe (does not revisit a person)' do
      node = Chart.new(@focal, generations: 10).build
      names = []
      collect = ->(n) { names << n.person.id; n.children.each { |c| collect.call(c) } }
      collect.call(node)
      assert_equal names.uniq, names
    end
  end
end
