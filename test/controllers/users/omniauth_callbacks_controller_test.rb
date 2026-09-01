# frozen_string_literal: true

require 'test_helper'

class Users::OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    # A realistic OmniAuth payload. The app's User.from_omniauth only reads
    # info.email, info.name and provider — it does not store a uid.
    @auth = OmniAuth::AuthHash.new(
      'provider' => 'google_oauth2',
      'uid' => '123456789',
      'info' => {
        'email' => 'oauth-user@gmail.com',
        'name' => 'OAuth User',
        'image' => 'http://example.com/photo.jpg'
      }
    )
    # Preserve the real class method so error-path stubs can be undone cleanly.
    @original_from_omniauth = User.method(:from_omniauth)
  end

  def teardown
    # Restore the genuine from_omniauth (some tests stub it) without nuking the
    # model's other class methods, and reset OmniAuth test state.
    User.define_singleton_method(:from_omniauth, @original_from_omniauth)
    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  # INHERITANCE / STRUCTURE
  test 'inherits from Devise::OmniauthCallbacksController' do
    assert Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  end

  test 'defines google_oauth2 and handle_auth methods' do
    methods = Users::OmniauthCallbacksController.instance_methods(false)
    assert_includes methods, :google_oauth2
    assert_includes methods, :handle_auth
  end

  test 'google_oauth2 action delegates to handle_auth' do
    controller = Users::OmniauthCallbacksController.new
    received = nil
    controller.define_singleton_method(:handle_auth) { |auth_type| received = auth_type }

    controller.google_oauth2

    assert_equal 'Google', received
  end

  test 'controller is properly namespaced under Users' do
    assert_equal 'Users::OmniauthCallbacksController', Users::OmniauthCallbacksController.name
  end

  test 'oauth callback routes work with custom controller' do
    assert_routing({ method: 'get', path: '/users/auth/google_oauth2/callback' },
                   { controller: 'users/omniauth_callbacks', action: 'google_oauth2' })
  end

  test 'User responds to from_omniauth' do
    assert_respond_to User, :from_omniauth
  end

  # HAPPY PATH — real from_omniauth
  test 'creates a user from omniauth data on first sign-in' do
    assert_difference 'User.count', 1 do
      get '/users/auth/google_oauth2/callback', env: { 'omniauth.auth' => @auth }
    end

    new_user = User.find_by(email: 'oauth-user@gmail.com')
    assert_not_nil new_user
    assert_equal 'google_oauth2', new_user.provider
    assert_not_nil new_user.confirmed_at
    assert_response :redirect
  end

  test 'signs in and redirects an existing omniauth user' do
    @user.skip_reconfirmation!
    @user.update!(email: 'oauth-user@gmail.com', provider: 'google_oauth2')

    assert_no_difference 'User.count' do
      get '/users/auth/google_oauth2/callback', env: { 'omniauth.auth' => @auth }
    end

    assert_response :redirect
    assert_includes flash[:notice], I18n.t('devise.omniauth_callbacks.success', kind: 'Google')
  end

  test 'records a user.omniauth audit event with ip and user agent' do
    @user.skip_reconfirmation!
    @user.update!(email: 'oauth-user@gmail.com', provider: 'google_oauth2')

    assert_difference '@user.events.count', 1 do
      get '/users/auth/google_oauth2/callback',
          env: { 'omniauth.auth' => @auth },
          headers: { 'REMOTE_ADDR' => '10.0.0.1', 'HTTP_USER_AGENT' => 'OAuth Test Browser' }
    end

    event = @user.events.last
    assert_equal 'user.omniauth', event.name
    assert_equal '10.0.0.1', event.data['ip_address']
    assert_equal 'OAuth Test Browser', event.data['user_agent']
  end

  test 'respects the active locale in the success flash' do
    @user.skip_reconfirmation!
    @user.update!(email: 'oauth-user@gmail.com', provider: 'google_oauth2')

    patch locale_change_unidentified_users_path('ja'), headers: { 'HTTP_REFERER' => root_path }

    get '/users/auth/google_oauth2/callback', env: { 'omniauth.auth' => @auth }
    assert_response :redirect
    assert_includes flash[:notice], I18n.t('devise.omniauth_callbacks.success', kind: 'Google', locale: :ja)
  end

  # FAILURE PATH — stub from_omniauth to return an unpersisted user
  test 'redirects to registration and creates no event when the user does not persist' do
    User.define_singleton_method(:from_omniauth) do |_auth|
      user = User.new(email: 'invalid-email')
      user.errors.add(:email, 'is invalid')
      user
    end

    assert_no_difference 'Event.count' do
      get '/users/auth/google_oauth2/callback', env: { 'omniauth.auth' => @auth }
    end

    assert_redirected_to new_user_registration_path
  end
end
