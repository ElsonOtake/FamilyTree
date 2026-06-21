# frozen_string_literal: true

# Return the partners/spouses of a person, with marriage and separation dates
# for each relationship.
class GetPartnersTool < ApplicationTool
  tool_name 'get_partners'
  description 'Get the partners or spouses of a person by id or slug, ' \
              'including marriage and separation dates for each relationship.'

  annotations(
    title: 'Get partners',
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

    couples = Couple.includes(:person1, :person2)
                    .where(person1_id: person.id)
                    .or(Couple.where(person2_id: person.id))

    relationships = couples.map do |couple|
      partner = couple.person1_id == person.id ? couple.person2 : couple.person1
      {
        partner: PersonPresenter.summary(partner),
        marriage_date: couple.marriage,
        separation_date: couple.separation,
        place: couple.local.presence
      }.compact
    end

    render(
      person: PersonPresenter.summary(person),
      count: relationships.size,
      partners: relationships
    )
  end
end
