# frozen_string_literal: true

# Return the parents of a person. The family tree models parents as the couple
# a person is a child of, so this exposes both the father/mother (by gender)
# and the full list of parents for couples that aren't a father/mother pair.
class GetParentsTool < ApplicationTool
  tool_name 'get_parents'
  description 'Get the parents of a person by id or slug. Returns the father ' \
              'and mother when identifiable, plus the full list of recorded ' \
              'parents.'

  annotations(
    title: 'Get parents',
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

    parents = person.couples.flat_map { |couple| [couple.person1, couple.person2] }.uniq

    render(
      person: PersonPresenter.summary(person),
      father: person.father && PersonPresenter.summary(person.father),
      mother: person.mother && PersonPresenter.summary(person.mother),
      parents: PersonPresenter.summaries(parents)
    )
  end
end
