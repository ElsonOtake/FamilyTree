# frozen_string_literal: true

# Return detailed information about a single person: name, gender, birth and
# death dates (which may be partial), age, and a human-readable life summary.
class GetPersonTool < ApplicationTool
  tool_name 'get_person'
  description 'Get detailed information about one person by id or slug: name, ' \
              'kanji, gender, birth/death dates, age and description.'

  annotations(
    title: 'Get person details',
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

    render(person: PersonPresenter.detail(person))
  end
end
