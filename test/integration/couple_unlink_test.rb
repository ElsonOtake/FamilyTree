# frozen_string_literal: true

require 'test_helper'

# Regression: unlinking a mate must hit the nested person-couple route so the
# controller's set_person (Person.find(params[:person_id])) has a person_id.
# The bare `couple` path (DELETE /casais/:id) lacks it and 404s.
class CoupleUnlinkTest < ActionDispatch::IntegrationTest
  setup do
    Role.find_or_create_by(name: 'admin')
    @user = users(:one)
    @user.add_role(:admin)
    post user_session_path, params: { user: { email: @user.email, password: 'password' } }

    @person = Person.create!(name: 'Ann', gender: 'F')
    @mate = Person.create!(name: 'Bob', gender: 'M')
    @couple = Couple.create!(person1: @person, person2: @mate)
  end

  test 'unlinking a mate soft-deletes the couple and redirects to the person' do
    assert_difference -> { Couple.count }, -1 do
      delete person_couple_path(@person, @couple)
    end

    assert_redirected_to person_url(@person)
    assert_nil Couple.find_by(id: @couple.id), 'couple should be scoped out (soft-deleted)'
    assert Couple.only_deleted.exists?(@couple.id), 'couple should be recoverable'
  end

  test 'the mate unlink button targets the nested person-couple path' do
    get person_path(@person)

    assert_response :success
    assert_select "a[href=?][data-turbo-method='delete']", person_couple_path(@person, @couple)
  end
end
