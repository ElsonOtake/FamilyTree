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

  test 'admin restore bounds the cascade so an old independent unlink is not resurrected' do
    ca = Couple.create!(person1: Person.create!(name: 'A1', gender: 'M'),
                        person2: Person.create!(name: 'A2', gender: 'F'))
    cb = Couple.create!(person1: Person.create!(name: 'B1', gender: 'M'),
                        person2: Person.create!(name: 'B2', gender: 'F'))
    kid = Person.create!(name: 'Kid', gender: 'X')
    Child.create!(couple: ca, person: kid, current_user: @admin)
    Child.create!(couple: cb, person: kid, current_user: @admin)

    old = Child.find_by(person_id: kid.id, couple_id: cb.id)
    old.destroy
    old.update_column(:deleted_at, 1.hour.ago) # unlinked from cb long before the person delete
    kid.destroy # cascades the ca link now

    put restore_admin_person_path(kid)

    assert_includes kid.reload.couples, ca
    assert_not_includes kid.couples, cb, 'the admin restore recovery_window must exclude the old unlink'
  end
end
