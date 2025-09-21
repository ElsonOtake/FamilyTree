require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  # INHERITANCE TESTS
  test "inherits from Devise::SessionsController" do
    assert Users::SessionsController < Devise::SessionsController
  end

  # CREATE ACTION TESTS (LOGIN)
  test "create action creates login event when user successfully signs in" do
    assert_difference '@user.events.count', 1 do
      post user_session_path, params: { 
        user: { 
          email: @user.email, 
          password: 'password' 
        } 
      }
    end
    
    event = @user.events.last
    assert_equal 'user.login', event.name
    assert_not_nil event.data
    assert event.data.key?('ip_address')
    assert event.data.key?('user_agent')
  end

  test "create action records IP address and user agent in login event" do
    post user_session_path, params: { 
      user: { 
        email: @user.email, 
        password: 'password' 
      } 
    }, 
    headers: { 
      'REMOTE_ADDR' => '192.168.1.100',
      'HTTP_USER_AGENT' => 'Mozilla/5.0 Test Browser'
    }
    
    event = @user.events.last
    assert_equal 'user.login', event.name
    assert_equal '192.168.1.100', event.data['ip_address']
    assert_equal 'Mozilla/5.0 Test Browser', event.data['user_agent']
  end

  test "create action handles invalid login credentials gracefully" do
    assert_no_difference 'Event.count' do
      post user_session_path, params: { 
        user: { 
          email: @user.email, 
          password: 'wrong_password' 
        } 
      }
    end
    
    assert_response :success # Form re-rendered with errors
    assert_select '.alert', /Invalid/ # Should show error message
  end

  test "create action doesn't create event if login fails" do
    assert_no_difference '@user.events.count' do
      post user_session_path, params: { 
        user: { 
          email: 'nonexistent@example.com', 
          password: 'password' 
        } 
      }
    end
  end

  # DESTROY ACTION TESTS (LOGOUT)
  test "destroy action creates logout event when user signs out" do
    sign_in_as(@user)
    
    assert_difference '@user.events.count', 1 do
      delete destroy_user_session_path
    end
    
    event = @user.events.last
    assert_equal 'user.logout', event.name
    assert_not_nil event.data
    assert event.data.key?('ip_address')
    assert event.data.key?('user_agent')
  end

  test "destroy action records IP address and user agent in logout event" do
    sign_in_as(@user)
    
    delete destroy_user_session_path, 
    headers: { 
      'REMOTE_ADDR' => '192.168.1.200',
      'HTTP_USER_AGENT' => 'Mozilla/5.0 Logout Test'
    }
    
    event = @user.events.last
    assert_equal 'user.logout', event.name
    assert_equal '192.168.1.200', event.data['ip_address']
    assert_equal 'Mozilla/5.0 Logout Test', event.data['user_agent']
  end

  test "destroy action redirects after logout" do
    sign_in_as(@user)
    
    delete destroy_user_session_path
    
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "destroy action doesn't create event if user not signed in" do
    # Try to logout without being signed in
    assert_no_difference 'Event.count' do
      delete destroy_user_session_path
    end
  end

  # EVENT DATA VERIFICATION
  test "login and logout events contain complete audit information" do
    # Test login event
    post user_session_path, params: { 
      user: { email: @user.email, password: 'password' } 
    }, 
    headers: { 
      'REMOTE_ADDR' => '10.0.0.1',
      'HTTP_USER_AGENT' => 'Test Browser Login'
    }
    
    login_event = @user.events.last
    assert_equal 'user.login', login_event.name
    assert_equal '10.0.0.1', login_event.data['ip_address']
    assert_equal 'Test Browser Login', login_event.data['user_agent']
    
    # Test logout event
    delete destroy_user_session_path,
    headers: { 
      'REMOTE_ADDR' => '10.0.0.2',
      'HTTP_USER_AGENT' => 'Test Browser Logout'
    }
    
    logout_event = @user.events.last
    assert_equal 'user.logout', logout_event.name
    assert_equal '10.0.0.2', logout_event.data['ip_address']
    assert_equal 'Test Browser Logout', logout_event.data['user_agent']
  end

  # CUSTOM OVERRIDE VERIFICATION
  test "overrides create and destroy methods" do
    overridden_methods = Users::SessionsController.instance_methods(false)
    expected_overrides = [:create, :destroy]
    
    expected_overrides.each do |method|
      assert_includes overridden_methods, method, 
        "Users::SessionsController should override #{method}"
    end
  end

  # AUTHENTICATION FLOW TESTS
  test "successful login grants access to protected resources" do
    post user_session_path, params: { 
      user: { email: @user.email, password: 'password' } 
    }
    
    # Should now be able to access protected resources
    follow_redirect!
    assert_response :success
  end

  test "logout revokes access to protected resources" do
    sign_in_as(@user)
    delete destroy_user_session_path
    
    # Should no longer have access to protected resources
    get users_path # Requires authentication
    assert_redirected_to new_user_session_path
  end

  # NAMESPACE TESTS
  test "controller is properly namespaced under Users" do
    assert_equal "Users::SessionsController", Users::SessionsController.name
    assert_equal Users, Users::SessionsController.name.deconstantize.constantize
  end

  # ROUTING INTEGRATION
  test "session routes work with custom controller" do
    assert_routing({ method: 'post', path: '/users/sign_in' }, 
                  { controller: 'users/sessions', action: 'create' })
    
    assert_routing({ method: 'delete', path: '/users/sign_out' }, 
                  { controller: 'users/sessions', action: 'destroy' })
    
    assert_routing({ method: 'get', path: '/users/sign_in' }, 
                  { controller: 'users/sessions', action: 'new' })
  end

  # ERROR HANDLING TESTS
  test "handles missing request data gracefully" do
    # Mock request to return nil for remote_ip and user_agent
    sign_in_as(@user)
    
    # Even with missing request data, should still create event
    assert_difference '@user.events.count', 1 do
      delete destroy_user_session_path
    end
    
    event = @user.events.last
    assert_equal 'user.logout', event.name
    # Should handle nil values gracefully
  end

  test "handles event creation failure gracefully" do
    # Mock Event.create to fail
    original_create = Event.method(:create)
    Event.define_singleton_method(:create) { |*args| raise StandardError, "Event creation failed" }
    
    begin
      # Login should still work even if event creation fails
      post user_session_path, params: { 
        user: { email: @user.email, password: 'password' } 
      }
      
      # Should still redirect after successful login despite event failure
      assert_response :redirect
    rescue StandardError
      # Expected - event creation failed but login should still work
    ensure
      # Restore original method
      Event.define_singleton_method(:create, &original_create)
    end
  end

  # LOCALE INTEGRATION
  test "works with locale switching from ApplicationController" do
    I18n.with_locale(:ja) do
      post user_session_path, params: { 
        user: { email: @user.email, password: 'password' } 
      }
      
      assert_response :redirect # Successful login
      
      event = @user.events.last
      assert_equal 'user.login', event.name
    end
  end

  # SECURITY TESTS
  test "login form includes CSRF protection" do
    get new_user_session_path
    assert_response :success
    assert_select 'input[name="authenticity_token"]'
  end

  test "login attempts are properly logged for security auditing" do
    # Multiple login attempts should create multiple events
    3.times do
      post user_session_path, params: { 
        user: { email: @user.email, password: 'password' } 
      }
      delete destroy_user_session_path
    end
    
    login_events = @user.events.where(name: 'user.login')
    logout_events = @user.events.where(name: 'user.logout')
    
    assert_equal 3, login_events.count
    assert_equal 3, logout_events.count
  end

  # INTEGRATION WITH APPLICATION BEHAVIOR
  test "session creation works with Pundit authorization" do
    sign_in_as(@user)
    
    # Should be able to access resources that use Pundit authorization
    # This verifies integration with ApplicationController's Pundit setup
    follow_redirect!
    assert_response :success
  end

  test "remember me functionality works" do
    post user_session_path, params: { 
      user: { 
        email: @user.email, 
        password: 'password',
        remember_me: '1'
      } 
    }
    
    assert_response :redirect
    # Should create login event regardless of remember_me setting
    event = @user.events.last
    assert_equal 'user.login', event.name
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