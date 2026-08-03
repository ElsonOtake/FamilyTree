# frozen_string_literal: true

require "test_helper"

class BirthOrderTest < ActiveSupport::TestCase
  test "orders oldest first by year, then month, then day" do
    y2010 = Person.create!(name: "y2010", gender: "X", birth: Date.new(2010, 6, 1))
    y2000_may = Person.create!(name: "y2000_may", gender: "X", birth: Date.new(2000, 5, 10))
    y2000_jan = Person.create!(name: "y2000_jan", gender: "X", birth: Date.new(2000, 1, 20))

    ordered = BirthOrder.sort([y2010, y2000_may, y2000_jan]).map(&:name)
    assert_equal %w[y2000_jan y2000_may y2010], ordered
  end

  test "people with no birth date sort last" do
    dated = Person.create!(name: "dated", gender: "X", birth: Date.new(1990, 1, 1))
    undated = Person.create!(name: "undated", gender: "X")

    assert_equal %w[dated undated], BirthOrder.sort([undated, dated]).map(&:name)
  end

  test "a known month outranks an unknown month within the same year" do
    year_only = Person.create!(name: "year_only", gender: "X", birth_year: 2000)
    year_month = Person.create!(name: "year_month", gender: "X", birth_year: 2000, birth_month: 3)

    assert_equal %w[year_month year_only], BirthOrder.sort([year_only, year_month]).map(&:name)
  end

  test "prefers the partial-date columns over the full birth date" do
    # birth_year says 1980 while the `birth` column says 2000: the partial column wins,
    # so this person sorts before a plain 1990 person.
    partial = Person.create!(name: "partial", gender: "X", birth_year: 1980, birth: Date.new(2000, 1, 1))
    plain = Person.create!(name: "plain", gender: "X", birth: Date.new(1990, 1, 1))

    assert_equal %w[partial plain], BirthOrder.sort([plain, partial]).map(&:name)
  end

  test "breaks ties by id so the order is stable" do
    first = Person.create!(name: "first", gender: "X", birth: Date.new(2000, 1, 1))
    second = Person.create!(name: "second", gender: "X", birth: Date.new(2000, 1, 1))

    assert first.id < second.id, "guard: created in id order"
    assert_equal %w[first second], BirthOrder.sort([second, first]).map(&:name)
  end
end
