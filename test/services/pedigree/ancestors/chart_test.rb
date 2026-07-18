# frozen_string_literal: true

require 'test_helper'

module Pedigree
  module Ancestors
    class ChartTest < ActiveSupport::TestCase
      setup do
        @user = User.create!(name: 'Recorder', email: 'rec@example.com',
                             password: 'password123', confirmed_at: Time.current)
        # focal <- (father + mother); father <- (grandfather + grandmother)
        @focal = Person.create!(name: 'Focal', gender: 'X')
        @father = Person.create!(name: 'Father', gender: 'M')
        @mother = Person.create!(name: 'Mother', gender: 'F')
        @parents = Couple.create!(person1: @father, person2: @mother)
        Child.create!(couple: @parents, person: @focal, current_user: @user)

        @grandfather = Person.create!(name: 'Grandfather', gender: 'M')
        @grandmother = Person.create!(name: 'Grandmother', gender: 'F')
        @grandparents = Couple.create!(person1: @grandfather, person2: @grandmother)
        Child.create!(couple: @grandparents, person: @father, current_user: @user)
      end

      def parents_of(node)
        node.marriages.first&.children || []
      end

      test 'models parents as children, father first, mother second' do
        node = Chart.new(@focal).build

        assert_equal @focal, node.person
        assert_equal 1, node.marriages.size
        assert_nil node.marriages.first.spouse
        assert_equal %w[Father Mother], parents_of(node).map { |p| p.person.name }
      end

      test 'walks ancestors with no generation limit' do
        node = Chart.new(@focal).build

        father_node = parents_of(node).first
        assert_equal 2, father_node.generation
        grandparents = parents_of(father_node)
        assert_equal 3, grandparents.first.generation
        assert_equal %w[Grandfather Grandmother], grandparents.map { |p| p.person.name }
        assert_empty parents_of(parents_of(node).last) # mother has no recorded parents
      end

      test 'a person with no recorded parents has no marriages' do
        assert_empty Chart.new(@grandmother).build.marriages
      end

      test 'a single recorded parent yields one child node' do
        solo = Person.create!(name: 'Solo Parent', gender: 'F')
        only = Couple.create!(person1: solo, person2: Person.create!(name: 'Ghost', gender: 'X'))
        kid = Person.create!(name: 'Kid', gender: 'M')
        Child.create!(couple: only, person: kid, current_user: @user)
        only.person2.destroy # leave a single surviving parent

        assert_equal ['Solo Parent'], Chart.new(kid).build.marriages.first.children.map { |c| c.person.name }
      end

      test 'excludes soft-deleted ancestors' do
        @grandfather.destroy

        node = Chart.new(@focal).build
        assert_equal ['Grandmother'], parents_of(parents_of(node).first).map { |p| p.person.name }
      end

      test 'returns nil for a missing root' do
        assert_nil Chart.new(nil).build
      end

      test 'is cycle-safe when data loops' do
        # Make the focal its own grandparent via a bad data loop.
        Child.create!(couple: @parents, person: @grandfather, current_user: @user)
        loopback = Couple.create!(person1: @focal, person2: Person.create!(name: 'X', gender: 'F'))
        Child.create!(couple: loopback, person: @father, current_user: @user)

        ids = []
        collect = lambda do |n|
          ids << n.person.id
          n.marriages.each { |m| m.children.each { |c| collect.call(c) } }
        end
        collect.call(Chart.new(@focal).build)
        assert_equal ids.uniq, ids
      end
    end
  end
end
