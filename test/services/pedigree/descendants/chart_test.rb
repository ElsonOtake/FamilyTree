# frozen_string_literal: true

require 'test_helper'

module Pedigree
  module Descendants
    class ChartTest < ActiveSupport::TestCase
      setup do
        @user = User.create!(name: 'Recorder', email: 'rec@example.com',
                             password: 'password123', confirmed_at: Time.current)
        # focal + spouse_a -> child_a ; focal + spouse_b -> child_b ; child_a -> grandchild
        @focal = Person.create!(name: 'Focal', gender: 'X')
        @spouse_a = Person.create!(name: 'Spouse A', gender: 'F')
        @spouse_b = Person.create!(name: 'Spouse B', gender: 'F')
        @child_a = Person.create!(name: 'Child A', gender: 'M')
        @child_b = Person.create!(name: 'Child B', gender: 'F')
        @grandchild = Person.create!(name: 'Grandchild', gender: 'X')

        @couple_a = Couple.create!(person1: @focal, person2: @spouse_a, marriage: '2001-01-01')
        @couple_b = Couple.create!(person1: @focal, person2: @spouse_b, marriage: '2002-01-01')
        Child.create!(couple: @couple_a, person: @child_a, current_user: @user)
        Child.create!(couple: @couple_b, person: @child_b, current_user: @user)

        @child_a_couple = Couple.create!(person1: @child_a, person2: Person.create!(name: 'In-law', gender: 'F'))
        Child.create!(couple: @child_a_couple, person: @grandchild, current_user: @user)
      end

      def children_of(node)
        node.marriages.first&.children || []
      end

      test 'each node has a single spouseless marriage' do
        node = Chart.new(@focal).build

        assert_equal @focal, node.person
        assert_equal 1, node.marriages.size
        assert_nil node.marriages.first.spouse
      end

      test 'merges children from every couple into one marriage' do
        node = Chart.new(@focal).build

        assert_equal ['Child A', 'Child B'], children_of(node).map { |c| c.person.name }
      end

      test 'orders children by birth date ascending, across couples, unknown last' do
        # Give the two children birth years so the younger sorts after the older,
        # and add a third child (other couple) with no birth date to fall last.
        @child_a.update!(birth_year: 2010)
        @child_b.update!(birth_year: 2005)
        no_date = Person.create!(name: 'No Date', gender: 'X')
        Child.create!(couple: @couple_a, person: no_date, current_user: @user)

        node = Chart.new(@focal).build
        assert_equal ['Child B', 'Child A', 'No Date'], children_of(node).map { |c| c.person.name }
      end

      test 'orders grandchildren by birth date too, at every generation' do
        # child_a has three children with out-of-order birth years; they must
        # come back oldest-first, proving the sort recurses past generation 2.
        gc_young = Person.create!(name: 'GC Young', gender: 'X', birth_year: 2020)
        gc_old = Person.create!(name: 'GC Old', gender: 'X', birth_year: 2000)
        gc_mid = Person.create!(name: 'GC Mid', gender: 'X', birth_year: 2010)
        [gc_young, gc_old, gc_mid].each { |p| Child.create!(couple: @child_a_couple, person: p, current_user: @user) }

        node = Chart.new(@focal).build
        child_a_node = children_of(node).find { |c| c.person == @child_a }
        grandchildren = children_of(child_a_node).map { |c| c.person.name }
        # @grandchild (no birth date) sorts last, after the three dated ones.
        assert_equal ['GC Old', 'GC Mid', 'GC Young', 'Grandchild'], grandchildren
      end

      test 'orders by the full birth date column when partial columns are blank' do
        # Real data often stores birth in the `birth` date column with the partial
        # birth_year/month/day columns left nil; the sort must read that too.
        parent = Person.create!(name: 'Root', gender: 'F')
        couple = Couple.create!(person1: parent, person2: Person.create!(name: 'P2', gender: 'M'))
        younger = Person.create!(name: 'Younger', gender: 'X', birth: Date.new(1974, 5, 1))
        older = Person.create!(name: 'Older', gender: 'X', birth: Date.new(1963, 2, 1))
        [younger, older].each { |p| Child.create!(couple: couple, person: p, current_user: @user) }

        node = Chart.new(parent).build
        assert_equal ['Older', 'Younger'], children_of(node).map { |c| c.person.name }
      end

      test 'orders by partial dates: same year sorts by month then day' do
        parent = Person.create!(name: 'Parent', gender: 'F')
        couple = Couple.create!(person1: parent, person2: Person.create!(name: 'P2', gender: 'M'))
        year_only = Person.create!(name: 'Year Only', gender: 'X', birth_year: 1990)
        march = Person.create!(name: 'March', gender: 'X', birth_year: 1990, birth_month: 3, birth_day: 2)
        june = Person.create!(name: 'June', gender: 'X', birth_year: 1990, birth_month: 6, birth_day: 1)
        [year_only, march, june].each { |p| Child.create!(couple: couple, person: p, current_user: @user) }

        node = Chart.new(parent).build
        assert_equal ['March', 'June', 'Year Only'], children_of(node).map { |c| c.person.name }
      end

      test 'walks descendants with no generation limit' do
        node = Chart.new(@focal).build

        child_a_node = children_of(node).first
        assert_equal 2, child_a_node.generation
        grandchildren = children_of(child_a_node)
        assert_equal %w[Grandchild], grandchildren.map { |c| c.person.name }
        assert_equal 3, grandchildren.first.generation
        assert_empty children_of(children_of(node).last) # Child B has no recorded children
      end

      test 'excludes pets when include_pets is false, keeps them when true' do
        pet = Person.create!(name: 'Rex', gender: 'P')
        Child.create!(couple: @couple_a, person: pet, current_user: @user)

        hidden = Chart.new(@focal, include_pets: false).build
        assert_not_includes children_of(hidden).map { |c| c.person.name }, 'Rex'

        shown = Chart.new(@focal, include_pets: true).build
        assert_includes children_of(shown).map { |c| c.person.name }, 'Rex'
      end

      test 'a person with no recorded children has no marriages' do
        assert_empty Chart.new(@grandchild).build.marriages
      end

      test 'excludes soft-deleted descendants' do
        @child_a.destroy

        node = Chart.new(@focal).build
        assert_equal ['Child B'], children_of(node).map { |c| c.person.name }
      end

      test 'returns nil for a missing root' do
        assert_nil Chart.new(nil).build
      end

      test 'is cycle-safe when data loops' do
        # Make the focal its own grandchild via a bad data loop.
        loopback = Couple.create!(person1: @grandchild, person2: Person.create!(name: 'X', gender: 'F'))
        Child.create!(couple: loopback, person: @focal, current_user: @user)

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
