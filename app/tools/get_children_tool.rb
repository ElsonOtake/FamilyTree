# frozen_string_literal: true

# Return the children of a person across all of their couples.
class GetChildrenTool < ApplicationTool
  tool_name 'get_children'
  description 'Get the children of a person by id or slug, across all of their ' \
              'relationships.'

  annotations(
    title: 'Get children',
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

    children = person.children

    render(
      person: PersonPresenter.summary(person),
      count: children.size,
      children: PersonPresenter.summaries(children)
    )
  end
end
