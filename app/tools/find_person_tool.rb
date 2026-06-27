# frozen_string_literal: true

# Search for people by name (or kanji) to obtain their id, which the other
# family-tree tools require. Names are not unique, so this returns candidates.
class FindPersonTool < ApplicationTool
  tool_name 'find_person'
  description 'Search the family tree for people by name or kanji. Romanization ' \
              'variants are tolerated (e.g. "Ohtake" matches "Otake", "Michio" ' \
              'matches "Mitio"). Returns a list of matching people with their ' \
              'id, gender, birth date and age. Use the returned id with the ' \
              'other family-tree tools.'

  annotations(
    title: 'Find person',
    read_only_hint: true,
    open_world_hint: false
  )

  arguments do
    required(:query).filled(:string).description('Full or partial name (or kanji) to search for')
    optional(:limit).filled(:integer, gt?: 0, lteq?: 50)
                    .description('Maximum number of results to return (default 10)')
  end

  def call(query:, limit: 10)
    # Match the canonicalized name (romanization-tolerant) or the raw kanji.
    normalized = Person.sanitize_sql_like(RomajiNormalizer.normalize(query))
    kanji = Person.sanitize_sql_like(query)
    people = Person.where('name_normalized LIKE :name OR kanji ILIKE :kanji',
                          name: "%#{normalized}%", kanji: "%#{kanji}%")
                   .limit(limit)

    render(
      query: query,
      count: people.size,
      results: PersonPresenter.summaries(people)
    )
  end
end
