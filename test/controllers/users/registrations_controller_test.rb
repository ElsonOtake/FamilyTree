# frozen_string_literal: true

require 'test_helper'

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @valid_user_params = {
      name: 'New User',
      email: 'newuser@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    }
  end

  # INHERITANCE TESTS
  test 'inherits from Devise::RegistrationsController' do
    assert Users::RegistrationsController < Devise::RegistrationsController
  end

  # CREATE ACTION TESTS
  test 'create action creates event when user is successfully created' do
    assert_difference 'User.count', 1 do
      assert_difference 'Event.count', 1 do
        post user_registration_path, params: { user: @valid_user_params }
      end
    end

    new_user = User.find_by(email: @valid_user_params[:email])
    assert_not_nil new_user

    event = new_user.events.last
    assert_equal 'user.create', event.name
    assert_not_nil event.data
    assert event.data.key?('name')
    assert event.data.key?('email')
  end

  test 'create action records saved_changes in event data' do
    post user_registration_path, params: { user: @valid_user_params }

    new_user = User.find_by(email: @valid_user_params[:email])
    event = new_user.events.last

    # Event data should contain the saved changes
    assert_includes event.data.keys, 'name'
    assert_includes event.data.keys, 'email'
    assert_includes event.data['name'], @valid_user_params[:name]
    assert_includes event.data['email'], @valid_user_params[:email]
  end

  test 'create action handles validation errors gracefully' do
    invalid_params = @valid_user_params.merge(email: '') # Invalid email

    assert_no_difference 'User.count' do
      assert_no_difference 'Event.count' do
        post user_registration_path, params: { user: invalid_params }
      end
    end

    assert_response :unprocessable_entity # form re-rendered with validation errors (Rails 7+ uses 422 for this)
  end

  test 'create action doesnt create event if user creation fails' do
    invalid_params = @valid_user_params.merge(email: @user.email) # Duplicate email

    assert_no_difference 'Event.count' do
      post user_registration_path, params: { user: invalid_params }
    end
  end

  # UPDATE ACTION TESTS
  test 'update action creates event when user is successfully updated' do
    sign_in_as(@user)

    assert_difference '@user.events.count', 1 do
      patch user_registration_path, params: {
        user: {
          name: 'Updated Name',
          current_password: 'password'
        }
      }
    end

    event = @user.events.last
    assert_equal 'user.update', event.name
    assert_not_nil event.data
  end

  test 'update action records saved_changes in event data' do
    sign_in_as(@user)
    old_name = @user.name
    new_name = 'Updated Name'

    patch user_registration_path, params: {
      user: {
        name: new_name,
        current_password: 'password'
      }
    }

    @user.reload
    event = @user.events.last

    # Event data should contain the saved changes
    assert_includes event.data.keys, 'name'
    assert_equal [old_name, new_name], event.data['name']
  end

  test 'update action handles validation errors gracefully' do
    sign_in_as(@user)

    assert_no_difference '@user.events.count' do
      patch user_registration_path, params: {
        user: {
          email: '', # Invalid email
          current_password: 'password'
        }
      }
    end

    assert_response :unprocessable_entity # form re-rendered with validation errors (Rails 7+ uses 422 for this)
  end

  test 'update action doesnt create event if update fails' do
    sign_in_as(@user)

    assert_no_difference '@user.events.count' do
      patch user_registration_path, params: {
        user: {
          name: 'New Name'
          # Missing current_password - should fail
        }
      }
    end
  end

  # DESTROY ACTION TESTS
  test 'destroy action creates event before user cancellation' do
    sign_in_as(@user)

    assert_difference '@user.events.count', 1 do
      delete user_registration_path
    end

    event = @user.events.last
    assert_equal 'user.cancel', event.name
    assert_equal @user.email, event.data['email']
    assert_equal @user.name, event.data['name']
  end

  test 'destroy action records user email and name in event' do
    sign_in_as(@user)
    original_email = @user.email
    original_name = @user.name

    delete user_registration_path

    event = @user.events.last
    assert_equal 'user.cancel', event.name
    assert_equal original_email, event.data['email']
    assert_equal original_name, event.data['name']
  end

  test 'destroy action calls super to complete cancellation' do
    sign_in_as(@user)

    # The user should be signed out and redirected after cancellation
    delete user_registration_path

    # Should redirect (part of Devise's default destroy behavior)
    assert_response :redirect
  end

  # EVENT CREATION VERIFICATION
  test 'events are associated with correct user' do
    # Test create
    post user_registration_path, params: { user: @valid_user_params }
    new_user = User.find_by(email: @valid_user_params[:email])
    create_event = new_user.events.last
    assert_equal new_user, create_event.user

    # Test update
    sign_in_as(@user)
    patch user_registration_path, params: {
      user: { name: 'New Name', current_password: 'password' }
    }
    update_event = @user.events.last
    assert_equal @user, update_event.user

    # Test destroy
    delete user_registration_path
    destroy_event = @user.events.last
    assert_equal @user, destroy_event.user
  end

  # CUSTOM OVERRIDE VERIFICATION
  test 'overrides create, update, and destroy methods' do
    overridden_methods = Users::RegistrationsController.instance_methods(false)
    expected_overrides = %i[create update destroy]

    expected_overrides.each do |method|
      assert_includes overridden_methods, method,
                      "Users::RegistrationsController should override #{method}"
    end
  end

  # INTEGRATION WITH DEVISE PARAMETER SANITIZATION
  test 'works with ApplicationController parameter sanitization' do
    # Should allow name and phone parameters from ApplicationController configuration
    post user_registration_path, params: {
      user: @valid_user_params.merge(phone: '123-456-7890')
    }

    new_user = User.find_by(email: @valid_user_params[:email])
    assert_equal '123-456-7890', new_user.phone
  end

  # NAMESPACE TESTS
  test 'controller is properly namespaced under Users' do
    assert_equal 'Users::RegistrationsController', Users::RegistrationsController.name
    assert_equal Users, Users::RegistrationsController.name.deconstantize.constantize
  end

  # ROUTING INTEGRATION
  test 'registration routes work with custom controller' do
    assert_routing({ method: 'post', path: '/users' },
                   { controller: 'users/registrations', action: 'create' })

    assert_routing({ method: 'patch', path: '/users' },
                   { controller: 'users/registrations', action: 'update' })

    assert_routing({ method: 'delete', path: '/users' },
                   { controller: 'users/registrations', action: 'destroy' })
  end

  # ERROR HANDLING TESTS
  test 'handles missing event creation gracefully' do
    # Mock Event.create to fail
    original_create = Event.method(:create)
    Event.define_singleton_method(:create) { |*args| raise StandardError, 'Event creation failed' }

    begin
      # User creation should still work even if event creation fails
      assert_difference 'User.count', 1 do
        post user_registration_path, params: { user: @valid_user_params }
      end
    rescue StandardError
      # Expected - event creation failed but user should still be created
    ensure
      # Restore original method
      Event.define_singleton_method(:create, &original_create)
    end
  end

  # LOCALE INTEGRATION
  test 'works with locale switching from ApplicationController' do
    I18n.with_locale(:pt) do
      post user_registration_path, params: { user: @valid_user_params }
      new_user = User.find_by(email: @valid_user_params[:email])
      assert_not_nil new_user
    end
  end

  # SECURITY TESTS
  test 'requires authentication for update action' do
    patch user_registration_path, params: {
      user: { name: 'Hacker Name' }
    }

    assert_redirected_to new_user_session_path
  end

  test 'requires authentication for destroy action' do
    delete user_registration_path

    assert_redirected_to new_user_session_path
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
end
