# frozen_string_literal: true

require 'test_helper'

# ActiveAdmin can list and restore soft-deleted (paranoia) records.
class AdminRestoreTest < ActionDispatch::IntegrationTest
  setup do
    Role.find_or_create_by(name: 'admin')
    @admin = users(:one)
    @admin.add_role(:admin)
    post user_session_path, params: { user: { email: @admin.email, password: 'password' } }

    @person = Person.create!(name: 'ZZDeletedGhost', gender: 'X')
    @person.destroy # soft delete
  end

  test 'default admin people index hides soft-deleted records' do
    get admin_people_path

    assert_response :success
    assert_no_match(/ZZDeletedGhost/, response.body)
  end

  test 'the Deleted scope lists soft-deleted records' do
    get admin_people_path(scope: 'deleted')

    assert_response :success
    assert_match(/ZZDeletedGhost/, response.body)
  end

  test 'the restore link renders inside the col-actions cell (spacing selector target)' do
    get admin_people_path(scope: 'deleted')

    assert_response :success
    assert_select 'td.col-actions a[href=?]', restore_admin_person_path(@person)
  end

  test 'the restore member action brings a person back' do
    assert Person.only_deleted.exists?(@person.id)

    put restore_admin_person_path(@person)

    assert_response :redirect
    assert Person.exists?(@person.id), 'person should be active again after restore'
    assert_not Person.only_deleted.exists?(@person.id)
  end

  test 'restoring records a person.restore audit event for the acting admin' do
    assert_difference -> { Event.where(name: 'person.restore', resource_id: @person.id).count }, 1 do
      put restore_admin_person_path(@person)
    end

    assert_equal @admin, Event.where(name: 'person.restore', resource_id: @person.id).last.user
  end

  test 'admin couples index renders when a couple member is soft-deleted' do
    live = Person.create!(name: 'LiveMember', gender: 'F')
    gone = Person.create!(name: 'DeletedMember', gender: 'M')
    Couple.create!(person1: live, person2: gone)
    gone.destroy # soft-delete a member; the couple stays

    get admin_couples_path

    assert_response :success
    assert_match(/LiveMember/, response.body)
    assert_match(/DeletedMember/, response.body) # deleted member's name still shown, not a 500
  end

  test 'restore works for a soft-deleted couple too' do
    p1 = Person.create!(name: 'A', gender: 'F')
    p2 = Person.create!(name: 'B', gender: 'M')
    couple = Couple.create!(person1: p1, person2: p2)
    couple.destroy

    put restore_admin_couple_path(couple)

    assert_response :redirect
    assert Couple.exists?(couple.id), 'couple should be active again after restore'
  end
end
