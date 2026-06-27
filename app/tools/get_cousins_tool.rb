# frozen_string_literal: true

# Return the first cousins of a person (children of the person's
# aunts and uncles, i.e. the siblings of their parents).
class GetCousinsTool < ApplicationTool
  tool_name 'get_cousins'
  description 'Get the first cousins of a person by id or slug (the children ' \
              'of their parents\' siblings).'

  annotations(
    title: 'Get cousins',
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

    cousins = person.cousins

    render(
      person: PersonPresenter.summary(person),
      count: cousins.size,
      cousins: PersonPresenter.summaries(cousins)
    )
  end
end
