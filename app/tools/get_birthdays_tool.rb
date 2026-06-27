# frozen_string_literal: true

# List people whose birthday falls within a named period: today, tomorrow, the
# current (Mon-Sun) week, or the current calendar month. Birthdays are matched
# by month/day only, so the year is ignored and partial dates without a year
# still match.
class GetBirthdaysTool < ApplicationTool
  tool_name 'get_birthdays'
  description 'List people with a birthday in a given period: "today", ' \
              '"tomorrow", "week" (the current Monday-Sunday week) or "month" ' \
              '(the current calendar month). Each result includes the birthday ' \
              'date, days until it, and the age the person will turn.'

  PERIODS = %w[today tomorrow week month].freeze

  annotations(
    title: 'Get birthdays',
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
    people = if period == 'month'
               Person.birthdays_in_month(today.month)
             else
               Person.birthdays_between(from, to)
             end

    render(
      period: period,
      from: from.iso8601,
      to: to.iso8601,
      count: people.size,
      birthdays: PersonPresenter.birthdays(people)
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
