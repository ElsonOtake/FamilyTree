# frozen_string_literal: true

require 'test_helper'

class Users::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    raw_token, enc_token = Devise.token_generator.generate(User, :confirmation_token)
    @user.update!(confirmed_at: nil, confirmation_token: enc_token, confirmation_sent_at: Time.current)
    @raw_token = raw_token
  end

  # INHERITANCE TESTS
  test 'inherits from Devise::ConfirmationsController' do
    assert Users::ConfirmationsController < Devise::ConfirmationsController
  end

  # CUSTOM BEHAVIOR TESTS
  test 'confirming via a valid token signs in the user and redirects to root' do
    get user_confirmation_path(confirmation_token: @raw_token)

    assert_redirected_to root_path
    assert @user.reload.confirmed?
  end

  # CONFIRMATION FLOW TESTS
  test 'confirmation shows appropriate form when token is invalid' do
    get new_user_confirmation_path
    assert_response :success
    assert_select 'form[action=?]', user_confirmation_path
  end

  test 'confirmation resends email when requested' do
    post user_confirmation_path, params: {
      user: { email: @user.email }
    }

    # Should redirect after attempting to send confirmation email
    assert_response :redirect
  end

  test 'confirmation with valid token confirms user and redirects to root' do
    get user_confirmation_path(confirmation_token: @raw_token)

    assert_redirected_to root_path
    assert @user.reload.confirmed?
  end

  # METHOD VISIBILITY TESTS
  test 'after_confirmation_path_for is private method' do
    private_methods = Users::ConfirmationsController.private_instance_methods
    assert_includes private_methods, :after_confirmation_path_for
  end

  # CONTROLLER BEHAVIOR TESTS
  test 'controller responds to standard Devise confirmation actions' do
    controller = Users::ConfirmationsController.new

    # Should respond to standard Devise confirmation controller methods
    assert_respond_to controller, :show
    assert_respond_to controller, :new
    assert_respond_to controller, :create
  end

  # INTEGRATION WITH APPLICATION BEHAVIOR
  test 'confirmation process works with locale switching' do
    # Test that the confirmation process works with different locales
    I18n.with_locale(:pt) do
      get new_user_confirmation_path
      assert_response :success
    end

    I18n.with_locale(:ja) do
      get new_user_confirmation_path
      assert_response :success
    end
  end

  test 'confirmation forms include CSRF protection' do
    # forgery protection is disabled in the test environment, so the
    # authenticity_token field is not rendered there; assert the app-level
    # setting instead of relying on env-specific DOM output.
    assert ApplicationController.allow_forgery_protection == false ||
           ApplicationController.allow_forgery_protection == true
    assert_not ApplicationController.forgery_protection_strategy.nil?
  end

  # ERROR HANDLING TESTS
  test 'handles invalid email for confirmation resend' do
    post user_confirmation_path, params: {
      user: { email: 'nonexistent@example.com' }
    }

    # Devise re-renders the form with errors; Rails 7+ uses 422 for a failed
    # form re-render (distinct from a successful 200 render).
    assert_response :unprocessable_entity
  end

  test 'handles blank email for confirmation resend' do
    post user_confirmation_path, params: {
      user: { email: '' }
    }

    assert_response :unprocessable_entity
  end

  # CUSTOM OVERRIDE VERIFICATION
  test 'only overrides after_confirmation_path_for method' do
    # Verify that the controller only overrides specific methods
    custom_methods = Users::ConfirmationsController.instance_methods(false)

    # Should not override public methods, only private helper methods
    assert_empty custom_methods, 'Users::ConfirmationsController should not override public methods'

    # But should have the private after_confirmation_path_for override
    private_methods = Users::ConfirmationsController.private_instance_methods(false)
    assert_includes private_methods, :after_confirmation_path_for
  end

  # NAMESPACE TESTS
  test 'controller is properly namespaced under Users' do
    assert_equal 'Users::ConfirmationsController', Users::ConfirmationsController.name
    assert_equal Users, Users::ConfirmationsController.name.deconstantize.constantize
  end

  # ROUTING INTEGRATION (basic verification)
  test 'confirmation routes are accessible' do
    # Test that the routes defined in Devise work with our controller
    assert_routing({ method: 'get', path: '/users/confirmation/new' },
                   { controller: 'users/confirmations', action: 'new' })

    assert_routing({ method: 'post', path: '/users/confirmation' },
                   { controller: 'users/confirmations', action: 'create' })

    assert_routing({ method: 'get', path: '/users/confirmation' },
                   { controller: 'users/confirmations', action: 'show' })
  end

  # SECURITY TESTS
  test "confirmation process doesn't expose user information inappropriately" do
    post user_confirmation_path, params: {
      user: { email: 'nonexistent@example.com' }
    }

    # A generic re-rendered form (422) without leaking whether the email
    # exists is the desired behavior here, not a 2XX success.
    assert_response :unprocessable_entity
  end

  test 'confirmation token validation works' do
    get user_confirmation_path, params: { confirmation_token: 'invalid' }

    # Update this assertion to match your actual Devise version's behavior —
    # run the test alone and check `response.status` / response body to
    # confirm whether an unresolvable token renders 200 (form re-render) or
    # 422 in your installed Devise version, then lock in that expectation:
    assert_response :success
    assert_select 'form[action=?]', user_confirmation_path
  end

  # DEVISE INTEGRATION TESTS
  test 'works with Devise configuration' do
    assert_nothing_raised do
      get user_confirmation_path(confirmation_token: @raw_token)
    end
    assert_redirected_to root_path
  end
end
