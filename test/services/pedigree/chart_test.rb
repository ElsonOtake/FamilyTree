# frozen_string_literal: true

require 'test_helper'

module Pedigree
  class ChartTest < ActiveSupport::TestCase
    setup do
      @user = User.create!(name: 'Recorder', email: 'rec@example.com',
                           password: 'password123', confirmed_at: Time.current)
      # focal + spouse -> child; child + child_spouse -> grandchild
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

    def children_of(node, marriage_index = 0)
      node.marriages[marriage_index].children
    end

    test 'builds a descendant tree grouped by marriage' do
      node = Chart.new(@focal, generations: 5).build

      assert_equal @focal, node.person
      assert_equal 1, node.marriages.size
      assert_equal @spouse, node.marriages.first.spouse
      assert_equal ['Child'], children_of(node).map { |c| c.person.name }
      assert_equal ['Grandchild'], children_of(children_of(node).first).map { |c| c.person.name }
    end

    test 'keeps each marriage spouse and children linked to that couple' do
      focal2 = Person.create!(name: 'Second Spouse', gender: 'F')
      other_couple = Couple.create!(person1: @focal, person2: focal2)
      other_child = Person.create!(name: 'Other Child', gender: 'M')
      Child.create!(couple: other_couple, person: other_child, current_user: @user)

      node = Chart.new(@focal, generations: 5).build

      assert_equal 2, node.marriages.size
      by_spouse = node.marriages.index_by { |m| m.spouse.name }
      assert_equal ['Child'], by_spouse['Spouse'].children.map { |c| c.person.name }
      assert_equal ['Other Child'], by_spouse['Second Spouse'].children.map { |c| c.person.name }
    end

    test 'orders a couple\'s children by birth date, oldest first, unknown last' do
      younger = Person.create!(name: 'Younger', gender: 'X', birth_year: 2010)
      older = Person.create!(name: 'Older', gender: 'X', birth: Date.new(2001, 6, 1)) # date column only
      no_date = Person.create!(name: 'No Date', gender: 'X')
      [younger, older, no_date].each { |p| Child.create!(couple: @couple, person: p, current_user: @user) }

      node = Chart.new(@focal, generations: 5).build
      # @child (no birth date) and No Date have none, so they trail the dated two by id.
      assert_equal ['Older', 'Younger', 'Child', 'No Date'], children_of(node).map { |c| c.person.name }
    end

    test 'excludes pets when include_pets is false, keeps them when true' do
      pet = Person.create!(name: 'Rex', gender: 'P')
      Child.create!(couple: @couple, person: pet, current_user: @user)

      hidden = Chart.new(@focal, generations: 5, include_pets: false).build
      assert_equal ['Child'], children_of(hidden).map { |c| c.person.name }

      shown = Chart.new(@focal, generations: 5, include_pets: true).build
      assert_includes children_of(shown).map { |c| c.person.name }, 'Rex'
    end

    test 'hides a pet spouse when include_pets is false' do
      pet_spouse = Person.create!(name: 'Whiskers', gender: 'P')
      Couple.create!(person1: @focal, person2: pet_spouse)

      node = Chart.new(@focal, generations: 5, include_pets: false).build
      assert node.marriages.map(&:spouse).compact.none?(&:pet?), 'pet spouse should be hidden'
    end

    test 'stops at the generation limit' do
      node = Chart.new(@focal, generations: 2).build

      child = children_of(node).first
      assert_equal 'Child', child.person.name
      assert child.childless?, 'generation 3 should not be built'
    end

    test 'excludes soft-deleted descendants' do
      @grandchild.destroy

      node = Chart.new(@focal, generations: 5).build
      assert_empty children_of(children_of(node).first)
    end

    test 'returns nil for a missing root' do
      assert_nil Chart.new(nil).build
    end

    test 'is cycle-safe (does not revisit a person)' do
      node = Chart.new(@focal, generations: 10).build
      ids = []
      collect = lambda do |n|
        ids << n.person.id
        n.marriages.each { |m| m.children.each { |c| collect.call(c) } }
      end
      collect.call(node)
      assert_equal ids.uniq, ids
    end
  end
end
