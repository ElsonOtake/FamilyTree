# frozen_string_literal: true

# Formats Person records into plain hashes for MCP tool responses.
#
# The family tree stores partial dates (year/month/day can each be missing), so
# this presenter leans on the model's existing formatting helpers
# (#birth_date_formatted, #date_text, #age_on_birthday) to produce values that
# are safe to read back to a user.
module PersonPresenter
  GENDER_LABELS = { 'M' => 'Male', 'F' => 'Female', 'P' => 'Pet', 'X' => 'Other' }.freeze

  module_function

  # Compact representation used for lists (e.g. search results, sibling lists).
  def summary(person)
    {
      id: person.id,
      slug: person.slug,
      name: person.name,
      kanji: person.kanji.presence,
      gender: person.gender,
      gender_label: GENDER_LABELS[person.gender],
      alive: person.alive?,
      birth_date: person.birth_date_formatted.presence,
      age: current_age(person)
    }.compact
  end

  # The person's current age in whole years, or nil when it can't be computed
  # (no birth year, or the person is deceased). When the month/day are known the
  # result accounts for whether this year's birthday has already passed;
  # otherwise it is a best estimate from the available parts.
  def current_age(person)
    return nil unless person.birth_year && person.alive?

    today = Date.current
    age = today.year - person.birth_year
    age -= 1 unless birthday_passed_this_year?(person, today)
    age
  end

  # Full representation including death info and a human-readable life summary.
  def detail(person)
    summary(person).merge(
      {
        death_date: person.death_date_formatted.presence,
        description: person.description.presence,
        life_summary: person.date_text.presence
      }.compact
    )
  end

  # Map a collection of people to summaries.
  def summaries(people)
    people.map { |person| summary(person) }
  end

  # Whether the person's birthday has already occurred (or is today) this year.
  # Falls back to partial comparisons when the day (or month) is unknown.
  def birthday_passed_this_year?(person, today)
    return today.month > person.birth_month if person.birth_month && person.birth_day.nil?
    return true if person.birth_month.nil?

    today.month > person.birth_month ||
      (today.month == person.birth_month && today.day >= person.birth_day)
  end
end
