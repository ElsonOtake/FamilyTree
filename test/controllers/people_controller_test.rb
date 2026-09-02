# frozen_string_literal: true

require 'test_helper'

class PeopleControllerTest < ActionDispatch::IntegrationTest
  setup do
    @person = people(:one)
    @user = users(:one)
    sign_in @user
  end

  test 'should get index' do
    get people_url
    assert_response :success
  end

  test 'should get new for default role' do
    get new_person_url
    assert_response :found
    assert_redirected_to root_path
  end

  test 'should get new for silver role' do
    @user.add_role(:silver)
    get new_person_url
    assert_response :success
  end

  test 'should create person for default role' do
    assert_no_difference('Person.count') do
      post people_url, params: { person: { alive: @person.alive, birth: @person.birth, death: @person.death,
                                           name: @person.name, description: @person.description,
                                           gender: @person.gender } }
    end

    assert_redirected_to root_path
  end

  test 'should create person for silver role' do
    @user.add_role(:silver)
    assert_difference('Person.count') do
      post people_url, params: { person: { alive: @person.alive, birth: @person.birth, death: @person.death,
                                           name: @person.name, description: @person.description,
                                           gender: @person.gender } }
    end

    assert_redirected_to person_url(Person.last)
  end

  test 'creates a new person as a child of a couple' do
    @user.add_role(:admin)
    dad = Person.create!(name: 'Create Dad', gender: 'M')
    mom = Person.create!(name: 'Create Mom', gender: 'F')
    couple = Couple.create!(person1: dad, person2: mom)

    assert_difference ['Person.count', 'Child.count'], 1 do
      post people_url, params: { person: { name: 'New Kid', gender: 'M', couple: couple.id } }
    end

    assert_redirected_to person_url(dad)
    assert_includes couple.reload.people.map(&:name), 'New Kid'
  end

  test 'should show person' do
    get person_url(@person)
    assert_response :success
  end

  test 'should get edit for default role' do
    get edit_person_url(@person)
    assert_response :found
    assert_redirected_to root_path
  end

  test 'should get edit for silver role' do
    @user.add_role(:silver)
    get edit_person_url(@person)
    assert_response :success
  end

  test 'should not update person for default role' do
    patch person_url(@person), params: { person: { alive: @person.alive, birth: @person.birth, death: @person.death,
                                                   name: @person.name, description: @person.description,
                                                   gender: @person.gender } }
    assert_redirected_to root_path
  end

  test 'should update person for silver role' do
    @user.add_role(:silver)
    patch person_url(@person), params: { person: { alive: @person.alive, birth: @person.birth, death: @person.death,
                                                   name: @person.name, description: @person.description,
                                                   gender: @person.gender } }
    assert_redirected_to person_url(@person)
  end

  test 'should not destroy person for default role' do
    assert_no_difference('Person.count') do
      delete person_url(@person)
    end

    assert_redirected_to root_path
  end

  test 'should not destroy person for silver role' do
    @user.add_role(:silver)
    assert_no_difference('Person.count') do
      delete person_url(@person)
    end

    assert_redirected_to root_path
  end

  test 'should destroy person for gold role' do
    @user.add_role(:gold)
    assert_difference('Person.count', -1) do
      delete person_url(@person)
    end

    assert_redirected_to people_url
  end

  test 'destroying a person records a person.destroy event for the current user' do
    @user.add_role(:admin)
    target = Person.create!(name: 'Doomed', gender: 'X')

    assert_difference -> { Event.where(name: 'person.destroy').count }, 1 do
      delete person_url(target)
    end

    event = Event.where(name: 'person.destroy').order(:id).last
    assert_equal @user, event.user
    assert_equal target.id, event.resource_id
    assert_equal 'Person', event.resource_type
    assert_equal 'Doomed', event.data['name']
    # RecordEvent must not also emit a person.unlink (its record_destroy is
    # couple-only; a person delete should be audited exactly once).
    assert_equal 0, Event.where(name: 'person.unlink').count
  end

  test 'cascaded child.unlink on person delete is attributed to the acting user' do
    @user.add_role(:admin)
    gp1 = Person.create!(name: 'GP1', gender: 'M')
    gp2 = Person.create!(name: 'GP2', gender: 'F')
    gpc = Couple.create!(person1: gp1, person2: gp2)
    kid = Person.create!(name: 'Kid', gender: 'X')
    Child.create!(couple: gpc, person: kid, current_user: @user)

    delete person_url(kid)

    unlink = Event.where(name: 'child.unlink', resource_id: kid.id).order(:id).last
    assert_not_nil unlink, 'person delete should cascade a child.unlink event'
    assert_equal @user, unlink.user, 'should be the acting admin, not the system user'
  end

  test 'birthdays action shows favorites when available' do
    # Create people with birthdays
    person_with_birthday = Person.create!(
      name: 'Birthday Person',
      birth_year: 1990,
      birth_month: 9,
      birth_day: 20
    )

    Person.create!(
      name: 'Non-favorite Person',
      birth_year: 1985,
      birth_month: 9,
      birth_day: 21
    )

    # Add one person to favorites
    @user.favorites.create!(person: person_with_birthday)

    travel_to Date.new(2025, 9, 20) do
      get birthdays_people_url
      assert_response :success

      # Should show the birthday page
      assert_select 'h1', text: /#{I18n.t('people.birthdays.title')}/

      # Should show the favorited person's name in the birthday listing
      assert_select 'body', text: /Birthday Person/
    end
  end

  test 'birthdays action falls back to all people when no favorites' do
    # Clear any existing favorites for this user
    @user.favorites.destroy_all

    # Create people with birthdays but no favorites
    Person.create!(
      name: 'Birthday Person',
      birth_year: 1990,
      birth_month: 9,
      birth_day: 20
    )

    travel_to Date.new(2025, 9, 20) do
      get birthdays_people_url
      assert_response :success

      # Should show the birthday page with all people
      assert_select 'h1', text: /#{I18n.t('people.birthdays.title')}/
      assert_select 'body', text: /Birthday Person/
    end
  end

  # TREE EXPORT AUDIT TESTS
  test 'descendants_full export records an audit event with settings' do
    assert_difference -> { Event.where(name: 'person.export_descendants_full').count }, 1 do
      get descendentes_completo_person_url(@person)
    end
    assert_response :success

    event = Event.where(name: 'person.export_descendants_full').order(:id).last
    assert_equal @user, event.user
    assert_equal @person, event.resource
    assert_equal 'descendants_full', event.data['type']
    assert_equal @user.tree_generations, event.data['generations']
    assert_equal @user.include_pets_in_tree, event.data['include_pets']
  end

  test 'descendants export records an audit event scoped to the person' do
    assert_difference -> { Event.where(name: 'person.export_descendants').count }, 1 do
      get descendentes_person_url(@person)
    end
    assert_response :success

    event = Event.where(name: 'person.export_descendants').order(:id).last
    assert_equal @person, event.resource
    assert_equal 'descendants', event.data['type']
  end

  test 'ancestry export records an audit event scoped to the person' do
    assert_difference -> { Event.where(name: 'person.export_ancestry').count }, 1 do
      get ascendentes_person_url(@person)
    end
    assert_response :success

    event = Event.where(name: 'person.export_ancestry').order(:id).last
    assert_equal @person, event.resource
    assert_equal 'ancestry', event.data['type']
  end

  private

  def sign_in(user)
    post user_session_path, params: { user: { email: user.email, password: 'password' } }
  end
end
