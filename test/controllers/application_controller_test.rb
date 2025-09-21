require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  def setup
    # Create roles if they don't exist
    Role.find_or_create_by(name: 'admin')
    Role.find_or_create_by(name: 'gold')
    Role.find_or_create_by(name: 'silver')
    Role.find_or_create_by(name: 'bronze')
    
    @admin_user = users(:one)
    @admin_user.add_role(:admin)
    
    @regular_user = users(:two)
    @regular_user.add_role(:bronze)
  end

  # Test helper controller for testing ApplicationController methods
  class TestController < ApplicationController
    def test_locale_switching
      render plain: I18n.locale.to_s
    end

    def test_authorization_error
      raise Pundit::NotAuthorizedError
    end

    def test_admin_required
      authenticate_admin_user!
      render plain: 'admin access granted'
    end
  end

  def setup_test_routes
    # Add test routes temporarily
    Rails.application.routes.draw do
      get '/test_locale_switching', to: 'application_controller_test/test#test_locale_switching'
      get '/test_authorization_error', to: 'application_controller_test/test#test_authorization_error'
      get '/test_admin_required', to: 'application_controller_test/test#test_admin_required'
    end
  end

  def teardown_test_routes
    # Reload original routes
    Rails.application.reload_routes!
  end

  # LOCALE SWITCHING TESTS
  test "switch_locale uses user locale when user is signed in" do
    @regular_user.update!(locale: 'ja')
    sign_in_as(@regular_user)
    
    setup_test_routes
    get '/test_locale_switching'
    teardown_test_routes
    
    assert_response :success
    assert_equal 'ja', response.body
  end

  test "switch_locale uses session locale when user not signed in" do
    setup_test_routes
    get '/test_locale_switching', params: {}, session: { locale: 'pt' }
    teardown_test_routes
    
    assert_response :success
    assert_equal 'pt', response.body
  end

  test "switch_locale uses default locale when no user or session locale" do
    setup_test_routes
    get '/test_locale_switching'
    teardown_test_routes
    
    assert_response :success
    assert_equal I18n.default_locale.to_s, response.body
  end

  test "switch_locale handles current_user being nil gracefully" do
    # Ensure no user is signed in
    setup_test_routes
    get '/test_locale_switching', params: {}, session: {}
    teardown_test_routes
    
    assert_response :success
    assert_equal I18n.default_locale.to_s, response.body
  end

  # ADMIN AUTHENTICATION TESTS
  test "authenticate_admin_user! allows admin users" do
    sign_in_as(@admin_user)
    
    setup_test_routes
    get '/test_admin_required'
    teardown_test_routes
    
    assert_response :success
    assert_equal 'admin access granted', response.body
  end

  test "authenticate_admin_user! redirects non-admin users" do
    sign_in_as(@regular_user)
    
    setup_test_routes
    get '/test_admin_required'
    teardown_test_routes
    
    assert_redirected_to root_path
    assert_equal I18n.t('active_admin.access_denied'), flash[:alert]
  end

  test "authenticate_admin_user! redirects unauthenticated users" do
    setup_test_routes
    get '/test_admin_required'
    teardown_test_routes
    
    assert_redirected_to root_path
    assert_equal I18n.t('active_admin.access_denied'), flash[:alert]
  end

  test "authenticate_admin_user! handles user without roles" do
    user_without_roles = User.create!(
      name: "No Roles User",
      email: "noroles@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    sign_in_as(user_without_roles)
    
    setup_test_routes
    get '/test_admin_required'
    teardown_test_routes
    
    assert_redirected_to root_path
    assert_equal I18n.t('active_admin.access_denied'), flash[:alert]
  end

  # AUTHORIZATION ERROR HANDLING TESTS
  test "user_not_authorized handles Pundit::NotAuthorizedError" do
    sign_in_as(@regular_user)
    
    setup_test_routes
    get '/test_authorization_error', headers: { "HTTP_REFERER" => users_path }
    teardown_test_routes
    
    assert_redirected_to users_path
    assert_equal I18n.t('errors.messages.unauthorized'), flash[:alert]
  end

  test "user_not_authorized redirects to root when no referer" do
    sign_in_as(@regular_user)
    
    setup_test_routes
    get '/test_authorization_error'
    teardown_test_routes
    
    assert_redirected_to root_path
    assert_equal I18n.t('errors.messages.unauthorized'), flash[:alert]
  end

  # PUNDIT INTEGRATION TESTS
  test "includes Pundit::Authorization module" do
    assert ApplicationController.ancestors.include?(Pundit::Authorization)
  end

  test "rescue_from Pundit::NotAuthorizedError is configured" do
    rescued_exceptions = ApplicationController.rescue_handlers.map(&:first)
    assert_includes rescued_exceptions, Pundit::NotAuthorizedError
  end

  # DEVISE PARAMETER CONFIGURATION TESTS
  test "configure_permitted_parameters allows name and phone for sign_up" do
    # This is tested indirectly through the registration controller
    # but we can verify the method exists and is called appropriately
    controller = ApplicationController.new
    assert_respond_to controller, :configure_permitted_parameters
  end

  # CALLBACK CONFIGURATION TESTS
  test "before_action configure_permitted_parameters is set for devise controllers" do
    callbacks = ApplicationController._process_action_callbacks
    devise_callback = callbacks.find { |cb| cb.filter == :configure_permitted_parameters }
    
    assert_not_nil devise_callback
    assert_equal :before, devise_callback.kind
    assert devise_callback.options[:if].call(double(devise_controller?: true))
    assert_not devise_callback.options[:if].call(double(devise_controller?: false))
  end

  test "around_action switch_locale is configured" do
    callbacks = ApplicationController._process_action_callbacks
    locale_callback = callbacks.find { |cb| cb.filter == :switch_locale }
    
    assert_not_nil locale_callback
    assert_equal :around, locale_callback.kind
  end

  # HELPER METHOD TESTS
  test "ApplicationController responds to expected methods" do
    controller = ApplicationController.new
    
    expected_methods = [
      :switch_locale,
      :authenticate_admin_user!,
      :configure_permitted_parameters,
      :user_not_authorized
    ]
    
    expected_methods.each do |method|
      assert_respond_to controller, method, "ApplicationController should respond to #{method}"
    end
  end

  # INHERITANCE TESTS
  test "inherits from ActionController::Base" do
    assert ApplicationController < ActionController::Base
  end

  test "includes Pundit::Authorization" do
    assert ApplicationController.included_modules.include?(Pundit::Authorization)
  end

  # ERROR HANDLING INTEGRATION
  test "error handling works with I18n" do
    # Verify that error messages use I18n
    I18n.with_locale(:en) do
      sign_in_as(@regular_user)
      
      setup_test_routes
      get '/test_authorization_error', headers: { "HTTP_REFERER" => users_path }
      teardown_test_routes
      
      assert_includes flash[:alert], I18n.t('errors.messages.unauthorized', locale: :en)
    end
  end

  test "locale switching works across different locales" do
    locales = ['pt', 'en', 'ja']
    
    locales.each do |locale|
      @regular_user.update!(locale: locale)
      sign_in_as(@regular_user)
      
      setup_test_routes
      get '/test_locale_switching'
      teardown_test_routes
      
      assert_response :success
      assert_equal locale, response.body
    end
  end

  private

  def sign_in_as(user)
    post user_session_path, params: { 
      user: { 
        email: user.email, 
        password: 'password' 
      } 
    }
  end

  # Helper double class for testing
  def double(methods = {})
    obj = Object.new
    methods.each do |method, return_value|
      obj.define_singleton_method(method) { return_value }
    end
    obj
  end
end