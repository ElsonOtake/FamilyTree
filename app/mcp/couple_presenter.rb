# frozen_string_literal: true

# Formats Couple records into plain hashes for MCP tool responses, reusing
# PersonPresenter for the two people in the couple.
module CouplePresenter
  module_function

  # Anniversary-focused entry: both partners plus the marriage date, this year's
  # anniversary, how many days away it is, and the anniversary number. A
  # separation date is included when present so the caller can tell the couple
  # is no longer together.
  def anniversary(couple)
    {
      couple_id: couple.id,
      partners: [PersonPresenter.summary(couple.person1), PersonPresenter.summary(couple.person2)],
      marriage_date: couple.marriage&.iso8601,
      anniversary: couple.anniversary_this_year&.iso8601,
      days_until_anniversary: couple.days_until_anniversary,
      years: couple.anniversary_years,
      separation_date: couple.separation&.iso8601,
      place: couple.local.presence
    }.compact
  end

  # Map a collection of couples to anniversary entries.
  def anniversaries(couples)
    couples.map { |couple| anniversary(couple) }
  end
end
