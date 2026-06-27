# frozen_string_literal: true

# List couples whose wedding anniversary falls within a named period: today,
# tomorrow, the current (Mon-Sun) week, or the current calendar month.
# Anniversaries are matched by the marriage date's month/day, so the year is
# ignored. Couples without a recorded marriage date are excluded.
class GetAnniversariesTool < ApplicationTool
  tool_name 'get_anniversaries'
  description 'List couples with a wedding anniversary in a given period: ' \
              '"today", "tomorrow", "week" (the current Monday-Sunday week) or ' \
              '"month" (the current calendar month). Each result includes both ' \
              'partners, the marriage date, days until the anniversary and the ' \
              'anniversary number. Couples with no marriage date are omitted.'

  PERIODS = %w[today tomorrow week month].freeze

  annotations(
    title: 'Get anniversaries',
    read_only_hint: true,
    open_world_hint: false
  )

  arguments do
    optional(:period).filled(:string, included_in?: PERIODS)
                     .description('One of: today, tomorrow, week, month (default: today)')
  end

  def call(period: 'today')
    today = Date.current
    from, to = range_for(period, today)
    couples = if period == 'month'
                Couple.anniversaries_in_month(today.month)
              else
                Couple.anniversaries_between(from, to)
              end

    render(
      period: period,
      from: from.iso8601,
      to: to.iso8601,
      count: couples.size,
      anniversaries: CouplePresenter.anniversaries(couples)
    )
  end

  private

  # Inclusive [from, to] date window described by the period.
  def range_for(period, today)
    case period
    when 'today'    then [today, today]
    when 'tomorrow' then [today + 1, today + 1]
    when 'week'     then [today.beginning_of_week, today.end_of_week]
    when 'month'    then [today.beginning_of_month, today.end_of_month]
    end
  end
end
