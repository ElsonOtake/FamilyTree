# frozen_string_literal: true

# Return the siblings of a person (other children of their parent couples).
class GetSiblingsTool < ApplicationTool
  tool_name 'get_siblings'
  description 'Get the siblings of a person by id or slug (other children of ' \
              'the same parents).'

  annotations(
    title: 'Get siblings',
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

    siblings = person.siblings

    render(
      person: PersonPresenter.summary(person),
      count: siblings.size,
      siblings: PersonPresenter.summaries(siblings)
    )
  end
end
