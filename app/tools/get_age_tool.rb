# frozen_string_literal: true

# Return the age of a person. Birth dates may be partial, and the person may be
# deceased, so this returns both a structured age (when computable) and a
# human-readable summary built from the model's own date helpers.
class GetAgeTool < ApplicationTool
  tool_name 'get_age'
  description 'Get the age of a person by id or slug. Handles partial birth ' \
              'dates and deceased people, returning a human-readable summary.'

  annotations(
    title: 'Get age',
    read_only_hint: true,
    open_world_hint: false
  )

  arguments do
    required(:person_id).filled(:string)
                        .description('The id (or slug) of the person')
  end

  def call(person_id:)
    person = find_person(person_id)
    return person_not_found(person_id) if person.nil?

    render(
      person: PersonPresenter.summary(person),
      alive: person.alive?,
      birth_date: person.birth_date_formatted.presence,
      death_date: person.death_date_formatted.presence,
      age_years: PersonPresenter.current_age(person),
      summary: person.date_text.presence
    )
  end
end
