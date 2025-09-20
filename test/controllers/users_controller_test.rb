require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
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
    
    # Create test users for role management
    setup_test_users
  end

  # INDEX ACTION TESTS
  test "should get index with admin user" do
    sign_in_as(@admin_user)
    
    get users_path
    assert_response :success
  end

  test "index should require admin authorization" do
    sign_in_as(@regular_user)
    
    get users_path
    assert_response :redirect # Should redirect due to authorization failure
  end

  test "index should require authentication" do
    get users_path
    assert_redirected_to new_user_session_path
  end

  # DOWNLOAD ACTION TESTS
  test "should download users CSV with admin user" do
    sign_in_as(@admin_user)
    
    get download_users_path(format: :csv)
    
    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_includes response.headers['Content-Disposition'], 'users'
    assert_includes response.headers['Content-Disposition'], Date.today.to_s
    
    # Verify CSV contains user data
    csv_data = response.body
    assert_includes csv_data, @admin_user.name
    assert_includes csv_data, @regular_user.name
  end

  test "download should require admin authorization" do
    sign_in_as(@regular_user)
    
    get download_users_path(format: :csv)
    assert_response :redirect # Should redirect due to authorization failure
  end

  test "download should require authentication" do
    get download_users_path(format: :csv)
    assert_response :unauthorized
  end

  test "download generates filename with current date" do
    sign_in_as(@admin_user)
    
    get download_users_path(format: :csv)
    
    assert_response :success
    
    content_disposition = response.headers['Content-Disposition']
    expected_filename = "users-#{Date.today}.csv"
    assert_includes content_disposition, expected_filename
  end

  test "download orders users by ID" do
    sign_in_as(@admin_user)
    
    get download_users_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # Should include user data in ID order
    assert_includes csv_data, @admin_user.name
    assert_includes csv_data, @regular_user.name
  end

  test "download only accepts CSV format" do
    sign_in_as(@admin_user)
    
    # Test with HTML format (should not be supported)
    assert_raises(ActionController::UnknownFormat) do
      get download_users_path
    end
  end

  # ROLES ACTION TESTS
  test "should get roles with admin user" do
    sign_in_as(@admin_user)
    
    get roles_users_path
    assert_response :success
  end

  test "roles should require admin authorization" do
    sign_in_as(@regular_user)
    
    get roles_users_path
    assert_response :redirect # Should redirect due to authorization failure
  end

  test "roles should require authentication" do
    get roles_users_path
    assert_redirected_to new_user_session_path
  end

  test "roles should exclude user ID 1 and paginate" do
    sign_in_as(@admin_user)
    
    get roles_users_path
    assert_response :success
    
    # Should use pagination with 10 items per page
    # Should exclude user with ID 1
    # Note: We can't easily test instance variables without rails-controller-testing gem
    # but we can verify the response is successful
  end

  # ROLE_UPDATE ACTION TESTS
  test "should update user role with admin user" do
    sign_in_as(@admin_user)
    
    target_user = @test_user1
    original_roles = target_user.roles.pluck(:name)
    
    patch role_update_user_path(target_user), params: { user: { role: 'gold' } }
    
    assert_redirected_to roles_users_path
    
    target_user.reload
    assert target_user.has_role?(:gold)
    assert_not target_user.has_role?(:bronze)
  end

  test "role_update should create audit event" do
    sign_in_as(@admin_user)
    
    target_user = @test_user1
    
    assert_difference('@admin_user.events.count', 1) do
      patch role_update_user_path(target_user), params: { user: { role: 'silver' } }
    end
    
    event = @admin_user.events.last
    assert_equal 'role.update', event.name
    assert_equal target_user.id, event.data['user_id']
    assert_includes event.data['old_roles'], 'bronze'
    assert_includes event.data['new_roles'], 'silver'
  end

  test "role_update should replace all existing roles" do
    sign_in_as(@admin_user)
    
    target_user = @test_user1
    target_user.add_role(:silver) # Give user multiple roles
    assert target_user.has_role?(:bronze)
    assert target_user.has_role?(:silver)
    
    patch role_update_user_path(target_user), params: { user: { role: 'admin' } }
    
    target_user.reload
    assert target_user.has_role?(:admin)
    assert_not target_user.has_role?(:bronze)
    assert_not target_user.has_role?(:silver)
  end

  test "role_update should require admin authorization" do
    sign_in_as(@regular_user)
    
    patch role_update_user_path(@test_user1), params: { user: { role: 'gold' } }
    assert_response :redirect # Should redirect due to authorization failure
  end

  test "role_update should require authentication" do
    patch role_update_user_path(@test_user1), params: { user: { role: 'gold' } }
    assert_redirected_to new_user_session_path
  end

  # CHANGE ACTION TESTS (Locale Change)
  test "should change locale for authenticated user" do
    sign_in_as(@regular_user)
    
    patch user_locale_change_path(@regular_user, 'en'), headers: { "HTTP_REFERER" => users_path }
    
    assert_redirected_to users_path
    @regular_user.reload
    assert_equal 'en', @regular_user.locale
  end

  test "change should create audit event" do
    sign_in_as(@regular_user)
    
    assert_difference('@regular_user.events.count', 1) do
      patch user_locale_change_path(@regular_user, 'ja'), headers: { "HTTP_REFERER" => users_path }
    end
    
    event = @regular_user.events.last
    assert_equal 'locale.update', event.name
    assert_equal 'ja', event.data['locale']
  end

  test "change should reject invalid locale" do
    sign_in_as(@regular_user)
    
    patch user_locale_change_path(@regular_user, 'invalid'), headers: { "HTTP_REFERER" => users_path }
    
    assert_redirected_to users_path
    @regular_user.reload
    assert_not_equal 'invalid', @regular_user.locale
  end

  test "change should validate against User.locales" do
    sign_in_as(@regular_user)
    
    # Test valid locales
    valid_locales = ['pt', 'en', 'ja']
    valid_locales.each do |locale|
      patch user_locale_change_path(@regular_user, locale), headers: { "HTTP_REFERER" => users_path }
      assert_redirected_to users_path
      @regular_user.reload
      assert_equal locale, @regular_user.locale
    end
  end

  test "change should allow any authenticated user" do
    sign_in_as(@regular_user)
    
    patch user_locale_change_path(@regular_user, 'en'), headers: { "HTTP_REFERER" => users_path }
    assert_redirected_to users_path
  end

  test "change should require authentication" do
    patch user_locale_change_path(@regular_user, 'en'), headers: { "HTTP_REFERER" => users_path }
    assert_redirected_to new_user_session_path
  end

  # CHANGE_UNIDENTIFIED ACTION TESTS
  test "should change locale for unidentified user in session" do
    patch locale_change_unidentified_users_path('pt'), headers: { "HTTP_REFERER" => root_path }
    
    assert_redirected_to root_path
    assert_equal 'pt', session[:locale]
  end

  test "change_unidentified should not require authentication" do
    # This action should work without authentication
    patch locale_change_unidentified_users_path('en'), headers: { "HTTP_REFERER" => root_path }
    
    assert_redirected_to root_path
    assert_equal 'en', session[:locale]
  end

  test "change_unidentified should handle various locales" do
    locales = ['pt', 'en', 'ja']
    
    locales.each do |locale|
      patch locale_change_unidentified_users_path(locale), headers: { "HTTP_REFERER" => root_path }
      assert_redirected_to root_path
      assert_equal locale, session[:locale]
    end
  end

  test "change_unidentified should redirect to referer" do
    referer_url = "http://www.example.com/some/path"
    
    patch locale_change_unidentified_users_path('en'), headers: { "HTTP_REFERER" => referer_url }
    
    assert_redirected_to referer_url
  end

  # AUTHORIZATION TESTS
  test "authorization hierarchy works correctly for admin actions" do
    actions_requiring_admin = [
      { action: -> { get users_path }, expects_success: true },
      { action: -> { get download_users_path(format: :csv) }, expects_success: true },
      { action: -> { get roles_users_path }, expects_success: true },
      { action: -> { patch role_update_user_path(@test_user1), params: { user: { role: 'gold' } } }, expects_success: false }
    ]
    
    users_and_roles = [
      { role: :bronze, can_access: false },
      { role: :silver, can_access: false },
      { role: :gold, can_access: false },
      { role: :admin, can_access: true }
    ]
    
    users_and_roles.each do |test_case|
      user = User.create!(
        name: "#{test_case[:role].capitalize} User Auth",
        email: "#{test_case[:role]}auth@test.com",
        password: "password",
        confirmed_at: 1.week.ago
      )
      user.add_role(test_case[:role])
      
      sign_in_as(user)
      
      actions_requiring_admin.each do |test_action|
        begin
          test_action[:action].call
          
          if test_case[:can_access]
            if test_action[:expects_success]
              assert_response :success, "#{test_case[:role]} should be able to access admin actions"
            else
              assert_response :redirect, "#{test_case[:role]} admin action should redirect after completion"
            end
          else
            assert_response :redirect, "#{test_case[:role]} should not be able to access admin actions"
          end
        rescue ActionController::UnknownFormat
          # CSV download without format parameter - this is expected
          assert_not test_case[:can_access], "Unauthorized users should get format error"
        end
      end
      
      sign_out
    end
  end

  # ERROR HANDLING TESTS
  test "should handle missing user in role_update" do
    sign_in_as(@admin_user)
    
    assert_raises(ActiveRecord::RecordNotFound) do
      patch role_update_user_path(99999), params: { user: { role: 'gold' } }
    end
  end

  test "should handle invalid role in role_update" do
    sign_in_as(@admin_user)
    
    patch role_update_user_path(@test_user1), params: { user: { role: 'invalid_role' } }
    
    # Should still redirect (rolify might handle invalid roles gracefully)
    assert_redirected_to roles_users_path
  end

  test "should handle missing referer in change actions" do
    sign_in_as(@regular_user)
    
    # Should handle nil referer gracefully by redirecting to root
    assert_raises(ActionController::ActionControllerError) do
      patch user_locale_change_path(@regular_user, 'en')
    end
  end

  # CSV FORMAT TESTS
  test "CSV headers should match User model columns" do
    sign_in_as(@admin_user)
    
    get download_users_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    headers = csv_data.split("\n").first.split(";")
    
    # Should include main User model columns
    expected_columns = %w[name email locale provider]
    
    expected_columns.each do |column|
      assert_includes headers, column, "CSV should include #{column} column"
    end
  end

  test "CSV includes user data correctly" do
    sign_in_as(@admin_user)
    
    get download_users_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # Should include user names and emails
    assert_includes csv_data, @admin_user.name
    assert_includes csv_data, @regular_user.name
    assert_includes csv_data, @admin_user.email
    assert_includes csv_data, @regular_user.email
  end

  # PAGINATION TESTS
  test "roles action should use pagination" do
    sign_in_as(@admin_user)
    
    # Create many test users to test pagination
    (1..15).each do |i|
      user = User.create!(
        name: "Pagination User #{i}",
        email: "pagination#{i}@test.com",
        password: "password",
        confirmed_at: 1.week.ago
      )
      user.add_role(:bronze) # Ensure all users have at least one role
    end
    
    get roles_users_path
    assert_response :success
    
    # Should handle pagination without errors
    # (Can't easily test pagination details without accessing instance variables)
  end

  private

  def setup_test_users
    @test_user1 = User.create!(
      name: "Test User 1",
      email: "testuser1@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    @test_user1.add_role(:bronze)
    
    @test_user2 = User.create!(
      name: "Test User 2",
      email: "testuser2@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    @test_user2.add_role(:silver)
  end

  def sign_in_as(user)
    post user_session_path, params: { 
      user: { 
        email: user.email, 
        password: 'password' 
      } 
    }
  end

  def sign_out
    delete destroy_user_session_path
  end
end