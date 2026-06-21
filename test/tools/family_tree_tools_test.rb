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

  test 'tools return an error for an unknown person' do
    result = call_tool(GetParentsTool, person_id: '999999')

    assert result[:error].present?
  end

  test 'a person with no recorded parents returns nil father and mother' do
    orphan = Person.create!(name: 'Lone Doe', gender: 'X')
    result = call_tool(GetParentsTool, person_id: orphan.id.to_s)

    assert_nil result[:father]
    assert_nil result[:mother]
    assert_empty result[:parents]
  end
end
