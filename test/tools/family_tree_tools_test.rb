# frozen_string_literal: true

require 'test_helper'

# Exercises the MCP tools that answer family-tree questions (parents, siblings,
# children, partners, age). Each tool returns a JSON string; we parse it and
# assert on the structured payload.
class FamilyTreeToolsTest < ActiveSupport::TestCase
  def setup
    # Linking child records logs an audit event via a user, so provide one
    # explicitly. This also avoids depending on User.system_user, which other
    # tests in this (pre-existing, leaky) suite are known to leave mocked.
    @user = User.create!(name: 'Recorder', email: 'recorder@example.com',
                         password: 'password123', confirmed_at: Time.current)

    # A small three-generation tree:
    #   father + mother  ->  child, sibling
    @father = Person.create!(name: 'John Doe', gender: 'M',
                             birth_year: 1970, birth_month: 1, birth_day: 10)
    @mother = Person.create!(name: 'Jane Doe', gender: 'F',
                             birth_year: 1972, birth_month: 3, birth_day: 5)
    @parents = Couple.create!(person1: @father, person2: @mother,
                              marriage: Date.new(1995, 6, 1))

    @child = Person.create!(name: 'Sam Doe', gender: 'X',
                            birth_year: 2000, birth_month: 6, birth_day: 15)
    @sibling = Person.create!(name: 'Pat Doe', gender: 'F',
                              birth_year: 2003, birth_month: 9, birth_day: 20)
    link_child(@child)
    link_child(@sibling)
  end

  def link_child(person)
    Child.create!(couple: @parents, person: person, current_user: @user)
  end

  def call_tool(klass, **args)
    JSON.parse(klass.new.call(**args), symbolize_names: true)
  end

  test 'find_person matches by partial name' do
    result = call_tool(FindPersonTool, query: 'Doe')

    assert_equal 4, result[:count]
    names = result[:results].map { |r| r[:name] }
    assert_includes names, 'John Doe'
    assert_includes names, 'Sam Doe'
  end

  test 'find_person respects the limit' do
    result = call_tool(FindPersonTool, query: 'Doe', limit: 2)

    assert_equal 2, result[:count]
  end

  test 'find_person matches each word independently across a middle name' do
    person = Person.create!(name: 'Elson Akio Otake', gender: 'M')

    # First + last name, skipping the middle name, and in reversed order.
    ['Elson Otake', 'otake elson', 'elson akio otake'].each do |query|
      result = call_tool(FindPersonTool, query: query)
      ids = result[:results].map { |r| r[:id] }
      assert_includes ids, person.id, "expected #{query.inspect} to find Elson Akio Otake"
    end
  end

  test 'find_person requires all words to match' do
    Person.create!(name: 'Elson Akio Otake', gender: 'M')

    result = call_tool(FindPersonTool, query: 'Elson Tanaka')

    assert_equal 0, result[:count]
  end

  test 'find_person ignores accents in the query and stored name' do
    person = Person.create!(name: 'Marcio Kazunori Otake', gender: 'M')

    # Accented query against an unaccented stored name, and vice versa.
    ['Márcio Otake', 'Marcio Otake'].each do |query|
      result = call_tool(FindPersonTool, query: query)
      ids = result[:results].map { |r| r[:id] }
      assert_includes ids, person.id, "expected #{query.inspect} to find Marcio Kazunori Otake"
    end
  end

  test 'find_person tolerates romanization variants' do
    person = Person.create!(name: 'Mitio Otake', gender: 'M')

    # Hepburn / long-vowel spellings should all resolve to the stored name.
    ['Michio Otake', 'Mitio Ohtake', 'ohtake', 'michio'].each do |query|
      result = call_tool(FindPersonTool, query: query)
      ids = result[:results].map { |r| r[:id] }
      assert_includes ids, person.id, "expected #{query.inspect} to find Mitio Otake"
    end
  end

  test 'get_person returns details and age' do
    travel_to Date.new(2024, 1, 1) do
      result = call_tool(GetPersonTool, person_id: @father.id.to_s)

      assert_equal 'John Doe', result[:person][:name]
      assert_equal 'Male', result[:person][:gender_label]
      # Born 1970-01-10; on 2024-01-01 the birthday hasn't happened yet, so 53.
      assert_equal 53, result[:person][:age]
    end
  end

  test 'get_parents returns father and mother' do
    result = call_tool(GetParentsTool, person_id: @child.id.to_s)

    assert_equal 'John Doe', result[:father][:name]
    assert_equal 'Jane Doe', result[:mother][:name]
    assert_equal 2, result[:parents].size
  end

  test 'get_siblings excludes the person themselves' do
    result = call_tool(GetSiblingsTool, person_id: @child.id.to_s)

    assert_equal 1, result[:count]
    assert_equal 'Pat Doe', result[:siblings].first[:name]
  end

  test 'get_children returns all children of the person' do
    result = call_tool(GetChildrenTool, person_id: @father.id.to_s)

    assert_equal 2, result[:count]
    names = result[:children].map { |c| c[:name] }
    assert_includes names, 'Sam Doe'
    assert_includes names, 'Pat Doe'
  end

  test 'get_partners returns spouse with marriage date' do
    result = call_tool(GetPartnersTool, person_id: @father.id.to_s)

    assert_equal 1, result[:count]
    rel = result[:partners].first
    assert_equal 'Jane Doe', rel[:partner][:name]
    assert_equal '1995-06-01', rel[:marriage_date]
  end

  test 'get_age handles a living person with a full birth date' do
    travel_to Date.new(2024, 7, 1) do
      result = call_tool(GetAgeTool, person_id: @child.id.to_s)

      assert result[:alive]
      assert_equal 24, result[:age_years]
    end
  end

  test 'get_age handles a deceased person' do
    deceased = Person.create!(name: 'Old Doe', gender: 'M',
                              birth_year: 1900, birth_month: 1, birth_day: 1,
                              death_year: 1980, death_month: 1, death_day: 1)
    result = call_tool(GetAgeTool, person_id: deceased.id.to_s)

    assert_not result[:alive]
    assert result[:summary].present?
  end

  test 'get_age reports no age for a person marked not alive without a death year' do
    # Born 1900, flagged deceased but no death date recorded. The age must not
    # be computed as if they were still living (e.g. 126 in 2026).
    deceased = Person.create!(name: 'Vintage Doe', gender: 'M', alive: false,
                              birth_year: 1900, birth_month: 1, birth_day: 1)
    result = call_tool(GetAgeTool, person_id: deceased.id.to_s)

    assert_not result[:alive]
    assert_nil result[:age_years]
  end

  test 'get_age suppresses an implausible age for unknown alive status' do
    travel_to Date.new(2026, 6, 27) do
      # alive: nil = unknown status; born 1900 would be 126, which is implausible.
      ancient = Person.create!(name: 'Ancient Doe', gender: 'M', alive: nil,
                               birth_year: 1900, birth_month: 1, birth_day: 1)
      result = call_tool(GetAgeTool, person_id: ancient.id.to_s)

      assert_nil result[:age_years]
    end
  end

  test 'get_age still reports a plausible age for unknown alive status' do
    travel_to Date.new(2026, 6, 27) do
      # Unknown status but born recently enough to be plausibly alive.
      young = Person.create!(name: 'Young Doe', gender: 'M', alive: nil,
                             birth_year: 1990, birth_month: 1, birth_day: 1)
      result = call_tool(GetAgeTool, person_id: young.id.to_s)

      assert_equal 36, result[:age_years]
    end
  end

  test 'tools return an error for an unknown person' do
    result = call_tool(GetParentsTool, person_id: '999999')

    assert result[:error].present?
  end

  test 'find_person tolerates underscores in a hyphenated slug' do
    # Slug for "John Doe" is "john-doe"; underscores should resolve too.
    assert_equal 'john-doe', @father.slug
    result = call_tool(GetChildrenTool, person_id: 'john_doe')

    assert_equal 2, result[:count]
  end

  test 'tools resolve a person by display name, not just slug' do
    # The id/slug argument also accepts a human-readable name, which is
    # slugified to match (e.g. "John Doe" -> "john-doe").
    %w[John\ Doe john\ doe].each do |identifier|
      result = call_tool(GetChildrenTool, person_id: identifier)
      assert_equal 2, result[:count], "expected #{identifier.inspect} to resolve to John Doe"
    end
  end

  test 'tools resolve a name with accents via slugification' do
    accented = Person.create!(name: 'José Antônio', gender: 'M')
    assert_equal 'jose-antonio', accented.slug

    result = call_tool(GetAgeTool, person_id: 'José Antônio')
    refute result[:error], 'expected accented name to resolve'
  end

  test 'tools resolve a unique partial name whose full slug has a suffix' do
    # Two people share the base name, so friendly_id appends a uniqueness suffix
    # to the slug. A partial name still resolves via the unambiguous name search.
    full = Person.create!(name: 'Satiye Sakamoto Otake', gender: 'F',
                          birth_year: 1941, birth_month: 1, birth_day: 1)

    ['Satiye Sakamoto', 'satiye-sakamoto'].each do |identifier|
      result = call_tool(GetAgeTool, person_id: identifier)
      assert_not result[:error], "expected #{identifier.inspect} to resolve"
      assert_equal full.id, result[:person][:id]
    end
  end

  test 'tools do not resolve an ambiguous name' do
    Person.create!(name: 'Aiko Sakamoto', gender: 'F')
    Person.create!(name: 'Bento Sakamoto', gender: 'M')

    # "Sakamoto" matches more than one person, so a get_* tool reports not found
    # (the caller should use find_person to disambiguate).
    result = call_tool(GetAgeTool, person_id: 'Sakamoto')

    assert result[:error].present?
  end

  test 'tools do not resolve a misspelled name' do
    Person.create!(name: 'Satiye Sakamoto Otake', gender: 'F')

    result = call_tool(GetAgeTool, person_id: 'satie-sakamoto')

    assert result[:error].present?
  end

  test 'a person with no recorded parents returns nil father and mother' do
    orphan = Person.create!(name: 'Lone Doe', gender: 'X')
    result = call_tool(GetParentsTool, person_id: orphan.id.to_s)

    assert_nil result[:father]
    assert_nil result[:mother]
    assert_empty result[:parents]
  end

  test 'get_cousins returns the children of the parents siblings' do
    # Extend the tree upward: grandparents -> @father, uncle.
    grandfather = Person.create!(name: 'Gramps Doe', gender: 'M')
    grandmother = Person.create!(name: 'Granny Doe', gender: 'F')
    grandparents = Couple.create!(person1: grandfather, person2: grandmother)
    uncle = Person.create!(name: 'Bob Doe', gender: 'M')
    Child.create!(couple: grandparents, person: @father, current_user: @user)
    Child.create!(couple: grandparents, person: uncle, current_user: @user)

    # The uncle's child is @child's first cousin.
    aunt_in_law = Person.create!(name: 'Sue Roe', gender: 'F')
    uncle_couple = Couple.create!(person1: uncle, person2: aunt_in_law)
    cousin = Person.create!(name: 'Kim Doe', gender: 'F')
    Child.create!(couple: uncle_couple, person: cousin, current_user: @user)

    result = call_tool(GetCousinsTool, person_id: @child.id.to_s)

    assert_equal 1, result[:count]
    names = result[:cousins].map { |c| c[:name] }
    assert_includes names, 'Kim Doe'
    # Own siblings are not cousins.
    assert_not_includes names, 'Pat Doe'
  end

  test 'get_cousins returns an empty list when there are none' do
    result = call_tool(GetCousinsTool, person_id: @child.id.to_s)

    assert_equal 0, result[:count]
    assert_empty result[:cousins]
  end

  test 'get_anniversaries finds couples with an anniversary today' do
    travel_to Date.new(2025, 6, 1) do
      # @parents married 1995-06-01; their 30th anniversary is today.
      result = call_tool(GetAnniversariesTool, period: 'today')

      ids = result[:anniversaries].map { |a| a[:couple_id] }
      assert_includes ids, @parents.id
      entry = result[:anniversaries].find { |a| a[:couple_id] == @parents.id }
      assert_equal 0, entry[:days_until_anniversary]
      assert_equal 30, entry[:years]
      assert_equal '1995-06-01', entry[:marriage_date]
      assert_equal 2, entry[:partners].size
    end
  end

  test 'get_anniversaries excludes couples without a marriage date' do
    a = Person.create!(name: 'No Date A', gender: 'M')
    b = Person.create!(name: 'No Date B', gender: 'F')
    undated = Couple.create!(person1: a, person2: b) # no marriage date

    travel_to Date.new(2025, 6, 1) do
      result = call_tool(GetAnniversariesTool, period: 'month')

      assert_not_includes result[:anniversaries].map { |x| x[:couple_id] }, undated.id
    end
  end

  test 'get_anniversaries month exposes a separation date when present' do
    travel_to Date.new(2025, 6, 15) do
      @parents.update!(separation: Date.new(2010, 1, 1))
      result = call_tool(GetAnniversariesTool, period: 'month')

      entry = result[:anniversaries].find { |a| a[:couple_id] == @parents.id }
      assert_equal '2010-01-01', entry[:separation_date]
    end
  end

  test 'get_birthdays finds people with a birthday today' do
    travel_to Date.new(2025, 6, 27) do
      today = Person.create!(name: 'Cake Doe', birth_year: 1990, birth_month: 6, birth_day: 27)
      Person.create!(name: 'Other Doe', birth_year: 1990, birth_month: 8, birth_day: 1)

      result = call_tool(GetBirthdaysTool, period: 'today')

      ids = result[:birthdays].map { |b| b[:id] }
      assert_includes ids, today.id
      entry = result[:birthdays].find { |b| b[:id] == today.id }
      assert_equal 0, entry[:days_until_birthday]
      assert_equal 35, entry[:turning_age]
      assert_equal '2025-06-27', entry[:birthday]
    end
  end

  test 'get_birthdays defaults to today and excludes other days' do
    travel_to Date.new(2025, 6, 27) do
      tomorrow = Person.create!(name: 'Soon Doe', birth_year: 1980, birth_month: 6, birth_day: 28)

      result = call_tool(GetBirthdaysTool)

      assert_equal 'today', result[:period]
      assert_not_includes result[:birthdays].map { |b| b[:id] }, tomorrow.id
    end
  end

  test 'get_birthdays week covers the current Monday-Sunday week' do
    travel_to Date.new(2025, 6, 27) do # Friday; week is Jun 23-29
      in_week = Person.create!(name: 'Week Doe', birth_year: 1990, birth_month: 6, birth_day: 24)
      out_week = Person.create!(name: 'Next Doe', birth_year: 1990, birth_month: 7, birth_day: 5)

      result = call_tool(GetBirthdaysTool, period: 'week')
      ids = result[:birthdays].map { |b| b[:id] }

      assert_includes ids, in_week.id
      assert_not_includes ids, out_week.id
    end
  end

  test 'get_birthdays month returns birthdays without a recorded year' do
    travel_to Date.new(2025, 6, 27) do
      no_year = Person.create!(name: 'Yearless Doe', birth_month: 6, birth_day: 3)
      other_month = Person.create!(name: 'Winter Doe', birth_month: 12, birth_day: 3)

      result = call_tool(GetBirthdaysTool, period: 'month')
      ids = result[:birthdays].map { |b| b[:id] }

      assert_includes ids, no_year.id
      assert_not_includes ids, other_month.id
    end
  end
end
