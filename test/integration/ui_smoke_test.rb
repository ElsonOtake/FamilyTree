# frozen_string_literal: true

require 'test_helper'

# Phase 0 safety net for the Bulma -> Tailwind UI refactor. These fast
# integration tests pin that every core page still RENDERS (HTTP 200 + key
# markup) so the visual refactor can be verified not to break behavior. They
# assert on stable structure (routes, form fields) rather than on CSS classes,
# which are expected to change.
class UiSmokeTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    # Grant full access so every page renders (some are role-gated); this is a
    # rendering safety net, not an authorization test.
    @user.add_role(:admin)
    @person = people(:one)
    sign_in @user
  end

  test 'people index renders with a new-person link and search form' do
    get people_url
    assert_response :success
    assert_select 'a[href=?]', new_person_path
    assert_select 'form'
  end

  test 'new person form renders all core fields' do
    get new_person_url
    assert_response :success
    assert_select 'input[name=?]', 'person[name]'
    assert_select 'input[name=?]', 'person[kanji]'
    assert_select 'input[name=?]', 'person[birth_year]'
    assert_select 'input[name=?]', 'person[birth_month]'
    assert_select 'input[name=?]', 'person[birth_day]'
  end

  test 'person show renders the detail page' do
    get person_url(@person)
    assert_response :success
    assert_select 'body'
  end

  test 'edit person form renders' do
    get edit_person_url(@person)
    assert_response :success
    assert_select 'input[name=?]', 'person[name]'
  end

  test 'birthdays page renders' do
    get birthdays_people_url
    assert_response :success
  end

  test 'person couples index renders' do
    get person_couples_url(@person)
    assert_response :success
  end

  test 'new couple form renders' do
    get new_person_couple_url(@person)
    assert_response :success
  end

  test 'sign-in page renders when signed out' do
    delete destroy_user_session_url
    get new_user_session_url
    assert_response :success
    assert_select 'input[name=?]', 'user[email]'
    assert_select 'input[name=?]', 'user[password]'
  end

  test 'about page renders' do
    get about_path
    assert_response :success
  end

  test 'statistics page renders' do
    get statistics_path
    assert_response :success
  end

  test 'mcp access page renders' do
    get mcp_access_users_path
    assert_response :success
  end

  test 'roles page renders' do
    get roles_users_path
    assert_response :success
    assert_select 'select'
  end

  test 'sign-up page renders when signed out' do
    delete destroy_user_session_url
    get new_user_registration_url
    assert_response :success
    assert_select 'input[name=?]', 'user[email]'
    assert_select 'input[name=?]', 'user[password]'
  end

  test 'people CSV download works' do
    get download_people_url(format: :csv)
    assert_response :success
    assert_equal 'text/csv', response.media_type
  end

  test 'pedigree tree renders as a PDF' do
    get arvore_person_url(@person, format: :pdf)
    assert_response :success
    assert_equal 'application/pdf', response.media_type
    assert response.body.start_with?('%PDF'), 'expected a PDF body'
  end

  private

  def sign_in(user)
    post user_session_path, params: { user: { email: user.email, password: 'password' } }
  end
end
