# frozen_string_literal: true

module Pedigree
  # Orders people oldest-first by their birth date, shared by the descendant
  # charts so children (and grandchildren, …) always read youngest-down.
  #
  # Birth can live in the partial-date columns or the full `birth` date column;
  # we prefer the partial columns and fall back to the date, mirroring how the
  # portrait label resolves the year (Pedigree::Chrome#years_line), so the order
  # always matches the years shown under the portraits. A (possibly partial)
  # date sorts ascending by year, then month, then day; people with no birth
  # date recorded fall to the end, ties broken by id so the order is stable.
  module BirthOrder
    module_function

    def sort(people)
      people.sort_by { |person| key(person) }
    end

    def key(person)
      birth = person.birth
      [component(person.birth_year, birth&.year),
       component(person.birth_month, birth&.month),
       component(person.birth_day, birth&.day),
       person.id]
    end

    # Prefer the partial-date column, fall back to the `birth` date's component,
    # then to +∞ so people with no date recorded sort last.
    def component(partial, dated)
      partial || dated || Float::INFINITY
    end
  end
end
