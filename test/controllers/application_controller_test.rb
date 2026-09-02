# frozen_string_literal: true

require 'test_helper'

# Exercises ApplicationController through real routes. The previous version drew
# throwaway routes and restored them with Rails.application.reload_routes!, but
# reload_routes! is broken by ActiveAdmin.routes in this app (it drops the Devise
# helpers), which leaked broken routes across the whole suite. Real routes avoid
# any global route mutation.
class ApplicationControllerTest < ActionDispatch::IntegrationTest
  def setup
    %w[admin gold silver bronze].each { |r| Role.find_or_create_by(name: r) }
    @admin_user = users(:one)
    @admin_user.add_role(:admin)
    @regular_user = users(:two)
    @regular_user.add_role(:bronze)
  end

  # STRUCTURE
  test 'inherits from ActionController::Base' do
    assert ApplicationController < ActionController::Base
  end

  test 'includes Pundit::Authorization' do
    assert ApplicationController.include?(Pundit::Authorization)
  end

  test 'responds to its helper methods' do
    controller = ApplicationController.new
    %i[switch_locale authenticate_admin_user! user_not_authorized configure_permitted_parameters].each do |method|
      assert controller.respond_to?(method, true), "ApplicationController should respond to #{method}"
    end
  end

  test 'rescue_from Pundit::NotAuthorizedError is configured' do
    handled = ApplicationController.rescue_handlers.map(&:first)
    assert_includes handled, 'Pundit::NotAuthorizedError'
  end

  test 'configure_permitted_parameters runs before devise actions' do
    filters = ApplicationController._process_action_callbacks.map(&:filter)
    assert_includes filters, :configure_permitted_parameters
  end

  test 'switch_locale is registered as an around_action' do
    callback = ApplicationController._process_action_callbacks.find { |cb| cb.filter == :switch_locale }
    assert_not_nil callback
    assert_equal :around, callback.kind
  end

  # ADMIN AUTHENTICATION (via ActiveAdmin's real /admin route)
  test 'authenticate_admin_user! lets admins into ActiveAdmin' do
    sign_in_as(@admin_user)
    get admin_people_path
    assert_response :success
  end

  test 'authenticate_admin_user! blocks non-admins from ActiveAdmin' do
    sign_in_as(@regular_user)
    get admin_people_path
    assert_redirected_to root_path
    assert_equal I18n.t('active_admin.access_denied'), flash[:alert]
  end

  test 'authenticate_admin_user! blocks unauthenticated users from ActiveAdmin' do
    get admin_people_path
    assert_redirected_to root_path
    assert_equal I18n.t('active_admin.access_denied'), flash[:alert]
  end

  # PUNDIT user_not_authorized (via a real forbidden action)
  test 'user_not_authorized redirects back with an alert on a forbidden action' do
    person = Person.create!(name: 'Deletable Person')
    sign_in_as(@regular_user) # bronze — may not destroy
    delete person_path(person), headers: { 'HTTP_REFERER' => people_path }
    assert_redirected_to people_path
    assert_equal I18n.t('errors.messages.unauthorized'), flash[:alert]
  end

  test 'user_not_authorized falls back to root when there is no referer' do
    person = Person.create!(name: 'Another Deletable Person')
    sign_in_as(@regular_user)
    delete person_path(person)
    assert_redirected_to root_path
    assert_equal I18n.t('errors.messages.unauthorized'), flash[:alert]
  end

  # LOCALE SWITCHING (around_action runs for the signed-in user's locale)
  test "switch_locale renders in the signed-in user's locale without error" do
    %w[pt en ja].each do |locale|
      @regular_user.update!(locale: locale)
      sign_in_as(@regular_user)
      get root_path
      assert_response :success
    end
  end

  private

  def sign_in_as(user)
    post user_session_path, params: { user: { email: user.email, password: 'password' } }
  end
end
