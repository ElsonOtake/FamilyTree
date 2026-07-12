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

  # NOTE: couples pages and the devise sign-in page are intentionally not
  # smoke-tested here (both fail in the test env for reasons unrelated to CSS):
  # - Every CouplesController action 404s under test because a set_couple
  #   before_action references a :show action that doesn't exist (a couples#show
  #   route is mapped but the method is missing); Rails 8's
  #   raise_on_missing_callback_actions raises AbstractController::ActionNotFound.
  #   Fix this while porting the couples views (Phase 4).
  # - devise/sessions/new calls omniauth_authorize_path, which isn't available in
  #   the integration-test view context. Cover it when porting Devise (Phase 5).

  test 'about page renders' do
    get about_path
    assert_response :success
  end

  test 'statistics page renders' do
    get statistics_path
    assert_response :success
  end

  test 'people CSV download works' do
    get download_people_url(format: :csv)
    assert_response :success
    assert_equal 'text/csv', response.media_type
  end

  private

  def sign_in(user)
    post user_session_path, params: { user: { email: user.email, password: 'password' } }
  end
end
