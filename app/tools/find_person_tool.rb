# frozen_string_literal: true

# Search for people by name (or kanji) to obtain their id, which the other
# family-tree tools require. Names are not unique, so this returns candidates.
class FindPersonTool < ApplicationTool
  tool_name 'find_person'
  description 'Search the family tree for people by name or kanji. Each word ' \
              'is matched independently and in any order, so "elson otake" ' \
              'finds "Elson Akio Otake". Romanization variants are tolerated ' \
              '(e.g. "Ohtake" matches "Otake", "Michio" matches "Mitio"). ' \
              'Returns a list of matching people with their id, gender, birth ' \
              'date and age. Use the returned id with the other family-tree tools.'

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
    # Split into words so a query matches regardless of word order or skipped
    # middle names: every word must appear in the (romanization-tolerant)
    # normalized name or the raw kanji.
    tokens = query.to_s.split
    return render(query: query, count: 0, results: []) if tokens.empty?

    people = tokens.reduce(Person.all) do |scope, token|
      normalized = Person.sanitize_sql_like(RomajiNormalizer.normalize(token))
      kanji = Person.sanitize_sql_like(token)
      scope.where('name_normalized LIKE :name OR kanji ILIKE :kanji',
                  name: "%#{normalized}%", kanji: "%#{kanji}%")
    end.limit(limit)

    render(
      query: query,
      count: people.size,
      results: PersonPresenter.summaries(people)
    )
  end
end
