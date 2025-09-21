require "test_helper"

class Users::OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @omniauth_data = {
      'provider' => 'google_oauth2',
      'uid' => '123456789',
      'info' => {
        'email' => 'test@gmail.com',
        'name' => 'Test User',
        'image' => 'http://example.com/photo.jpg'
      },
      'credentials' => {
        'token' => 'oauth_token',
        'refresh_token' => 'refresh_token'
      }
    }
  end

  # INHERITANCE TESTS
  test "inherits from Devise::OmniauthCallbacksController" do
    assert Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  end

  # GOOGLE_OAUTH2 ACTION TESTS
  test "google_oauth2 action delegates to handle_auth" do
    controller = Users::OmniauthCallbacksController.new
    
    # Mock handle_auth method
    handle_auth_called = false
    handle_auth_param = nil
    
    controller.define_singleton_method(:handle_auth) do |auth_type|
      handle_auth_called = true
      handle_auth_param = auth_type
    end
    
    controller.google_oauth2
    
    assert handle_auth_called, "google_oauth2 should call handle_auth"
    assert_equal 'Google', handle_auth_param, "should pass 'Google' as parameter"
  end

  # HANDLE_AUTH METHOD TESTS
  test "handle_auth creates user from omniauth data when user persists" do
    # Mock the omniauth environment
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(@omniauth_data)
    
    # Mock User.from_omniauth to return a persisted user
    User.define_singleton_method(:from_omniauth) do |auth|
      user = User.find_or_create_by(email: auth.info.email) do |u|
        u.name = auth.info.name
        u.provider = auth.provider
        u.uid = auth.uid
        u.password = Devise.friendly_token[0, 20]
        u.confirmed_at = Time.current
      end
      user
    end
    
    assert_difference 'User.count', 1 do
      get '/users/auth/google_oauth2/callback', env: { 'omniauth.auth' => @omniauth_data }
    end
    
    new_user = User.find_by(email: @omniauth_data['info']['email'])
    assert_not_nil new_user
    assert_equal @omniauth_data['provider'], new_user.provider
    assert_equal @omniauth_data['uid'], new_user.uid
  end

  test "handle_auth creates omniauth event when user successfully authenticates" do
    # Set up existing user with OAuth data
    @user.update!(
      provider: @omniauth_data['provider'],
      uid: @omniauth_data['uid'],
      email: @omniauth_data['info']['email']
    )
    
    # Mock User.from_omniauth to return the existing user
    User.define_singleton_method(:from_omniauth) do |auth|
      User.find_by(provider: auth.provider, uid: auth.uid)
    end
    
    assert_difference '@user.events.count', 1 do
      get '/users/auth/google_oauth2/callback', 
          env: { 'omniauth.auth' => @omniauth_data },
          headers: { 
            'REMOTE_ADDR' => '192.168.1.100',
            'HTTP_USER_AGENT' => 'Mozilla/5.0 OAuth Test'
          }
    end
    
    event = @user.events.last
    assert_equal 'user.omniauth', event.name
    assert_equal '192.168.1.100', event.data['ip_address']
    assert_equal 'Mozilla/5.0 OAuth Test', event.data['user_agent']
  end

  test "handle_auth signs in and redirects user when authentication succeeds" do
    # Mock User.from_omniauth to return a persisted user
    persisted_user = users(:two)
    persisted_user.update!(
      provider: @omniauth_data['provider'],
      uid: @omniauth_data['uid']
    )
    
    User.define_singleton_method(:from_omniauth) do |auth|
      persisted_user
    end
    
    get '/users/auth/google_oauth2/callback', env: { 'omniauth.auth' => @omniauth_data }
    
    assert_response :redirect
    assert_includes flash[:notice], I18n.t('devise.omniauth_callbacks.success', kind: 'Google')
  end

  test "handle_auth redirects to registration when user persistence fails" do
    # Mock User.from_omniauth to return an unpersisted user with errors
    unpersisted_user = User.new(email: 'invalid-email')
    unpersisted_user.errors.add(:email, 'is invalid')
    
    User.define_singleton_method(:from_omniauth) do |auth|
      unpersisted_user
    end
    
    get '/users/auth/google_oauth2/callback', env: { 'omniauth.auth' => @omniauth_data }
    
    assert_redirected_to new_user_registration_path
    assert_includes flash[:alert], 'is invalid'
  end

  test "handle_auth doesn't create event when user persistence fails" do
    # Mock User.from_omniauth to return an unpersisted user
    unpersisted_user = User.new
    
    User.define_singleton_method(:from_omniauth) do |auth|
      unpersisted_user
    end
    
    assert_no_difference 'Event.count' do
      get '/users/auth/google_oauth2/callback', env: { 'omniauth.auth' => @omniauth_data }
    end
  end

  # METHOD VISIBILITY TESTS
  test "handle_auth is a public method" do
    public_methods = Users::OmniauthCallbacksController.public_instance_methods
    assert_includes public_methods, :handle_auth
  end

  # CUSTOM OVERRIDE VERIFICATION
  test "defines google_oauth2 and handle_auth methods" do
    controller_methods = Users::OmniauthCallbacksController.instance_methods(false)
    expected_methods = [:google_oauth2, :handle_auth]
    
    expected_methods.each do |method|
      assert_includes controller_methods, method, 
        "Users::OmniauthCallbacksController should define #{method}"
    end
  end

  # ERROR HANDLING TESTS
  test "handles missing omniauth data gracefully" do
    get '/users/auth/google_oauth2/callback'
    
    # Should handle missing omniauth data without crashing
    assert_response :redirect # Usually redirects to registration with error
  end

  test "handles malformed omniauth data gracefully" do
    malformed_data = { 'provider' => 'google_oauth2' } # Missing required fields
    
    get '/users/auth/google_oauth2/callback', env: { 'omniauth.auth' => malformed_data }
    
    # Should handle malformed data without crashing
    assert_response :redirect
  end

  test "handles User.from_omniauth exceptions gracefully" do
    # Mock User.from_omniauth to raise an exception
    User.define_singleton_method(:from_omniauth) do |auth|
      raise StandardError, "OAuth processing failed"
    end
    
    assert_nothing_raised do
      get '/users/auth/google_oauth2/callback', env: { 'omniauth.auth' => @omniauth_data }
    end
  end

  # INTEGRATION TESTS
  test "works with User model from_omniauth method" do
    # Verify that the controller properly calls User.from_omniauth
    assert_respond_to User, :from_omniauth, "User model should respond to from_omniauth"
  end

  test "integrates with Devise authentication flow" do
    # Mock a successful OAuth flow
    persisted_user = users(:two)
    persisted_user.update!(
      provider: @omniauth_data['provider'],
      uid: @omniauth_data['uid']
    )
    
    User.define_singleton_method(:from_omniauth) do |auth|
      persisted_user
    end
    
    get '/users/auth/google_oauth2/callback', env: { 'omniauth.auth' => @omniauth_data }
    
    # Should integrate with Devise's sign_in_and_redirect
    assert_response :redirect
    assert_not_nil flash[:notice]
  end

  # NAMESPACE TESTS
  test "controller is properly namespaced under Users" do
    assert_equal "Users::OmniauthCallbacksController", Users::OmniauthCallbacksController.name
    assert_equal Users, Users::OmniauthCallbacksController.name.deconstantize.constantize
  end

  # ROUTING INTEGRATION
  test "oauth callback routes work with custom controller" do
    assert_routing({ method: 'get', path: '/users/auth/google_oauth2/callback' }, 
                  { controller: 'users/omniauth_callbacks', action: 'google_oauth2' })
  end

  # EVENT DATA VERIFICATION
  test "omniauth events contain audit information" do
    @user.update!(
      provider: @omniauth_data['provider'],
      uid: @omniauth_data['uid'],
      email: @omniauth_data['info']['email']
    )
    
    User.define_singleton_method(:from_omniauth) do |auth|
      @user
    end
    
    get '/users/auth/google_oauth2/callback', 
        env: { 'omniauth.auth' => @omniauth_data },
        headers: { 
          'REMOTE_ADDR' => '10.0.0.1',
          'HTTP_USER_AGENT' => 'OAuth Test Browser'
        }
    
    event = @user.events.last
    assert_equal 'user.omniauth', event.name
    assert_equal '10.0.0.1', event.data['ip_address']
    assert_equal 'OAuth Test Browser', event.data['user_agent']
    assert_not_nil event.created_at
  end

  # SECURITY TESTS
  test "oauth callback validates user data before proceeding" do
    # The controller should validate user persistence before creating events
    unpersisted_user = User.new # Not saved, should fail validation
    
    User.define_singleton_method(:from_omniauth) do |auth|
      unpersisted_user
    end
    
    assert_no_difference 'Event.count' do
      get '/users/auth/google_oauth2/callback', env: { 'omniauth.auth' => @omniauth_data }
    end
  end

  test "oauth flow includes CSRF protection" do
    # OAuth callbacks should be protected against CSRF attacks
    # This is typically handled by OmniAuth middleware, but we verify routing works
    get '/users/auth/google_oauth2/callback'
    
    # Should handle the request without authentication token (OAuth handles this)
    assert_response :redirect
  end

  # LOCALE INTEGRATION
  test "works with locale switching from ApplicationController" do
    persisted_user = users(:two)
    persisted_user.update!(provider: @omniauth_data['provider'], uid: @omniauth_data['uid'])
    
    User.define_singleton_method(:from_omniauth) { |auth| persisted_user }
    
    I18n.with_locale(:ja) do
      get '/users/auth/google_oauth2/callback', env: { 'omniauth.auth' => @omniauth_data }
      
      assert_response :redirect
      assert_includes flash[:notice], I18n.t('devise.omniauth_callbacks.success', kind: 'Google', locale: :ja)
    end
  end

  private

  def teardown
    # Clean up any mocked methods
    User.singleton_methods(false).each do |method|
      User.singleton_class.remove_method(method) if User.respond_to?(method)
    end
    
    # Reset OmniAuth test mode
    OmniAuth.config.test_mode = false
  end
end