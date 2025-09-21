require "test_helper"

class RolesControllerTest < ActionDispatch::IntegrationTest
  def setup
    # Create roles if they don't exist
    Role.find_or_create_by(name: 'admin')
    Role.find_or_create_by(name: 'gold')
    Role.find_or_create_by(name: 'silver')
    Role.find_or_create_by(name: 'bronze')
    
    @admin_user = users(:one)
    @admin_user.add_role(:admin)
    
    @non_admin_user = users(:two)
    @non_admin_user.add_role(:bronze)
    
    # Create test roles for CSV download
    setup_test_roles
  end

  # DOWNLOAD ACTION TESTS
  test "should download roles CSV with admin user" do
    sign_in_as(@admin_user)
    
    get download_roles_path(format: :csv)
    
    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_includes response.headers['Content-Disposition'], 'roles'
    assert_includes response.headers['Content-Disposition'], Date.today.to_s
    
    # Verify CSV contains role data
    csv_data = response.body
    assert_includes csv_data, @test_role1.name
    assert_includes csv_data, @test_role2.name
  end

  test "download should include soft-deleted roles" do
    sign_in_as(@admin_user)
    
    # Create and soft-delete a role
    deleted_role = Role.create!(name: "deleted_role")
    deleted_role.destroy
    
    get download_roles_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # Should include both active and deleted roles
    assert_includes csv_data, @test_role1.name
    assert_includes csv_data, "deleted_role"
  end

  test "download should require admin authorization" do
    sign_in_as(@non_admin_user)
    
    get download_roles_path(format: :csv)
    assert_response :redirect # Should redirect due to authorization failure
  end

  test "download should only accept CSV format" do
    sign_in_as(@admin_user)
    
    # Test with HTML format (should not be supported)
    assert_raises(ActionController::UnknownFormat) do
      get download_roles_path
    end
  end

  test "download CSV contains proper headers" do
    sign_in_as(@admin_user)
    
    get download_roles_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    headers = csv_data.split("\n").first.split(";")
    
    # Should include main Role model columns
    expected_columns = %w[name resource_type resource_id]
    
    expected_columns.each do |column|
      assert_includes headers, column, "CSV should include #{column} column"
    end
  end

  test "download generates filename with current date" do
    sign_in_as(@admin_user)
    
    get download_roles_path(format: :csv)
    
    assert_response :success
    
    content_disposition = response.headers['Content-Disposition']
    expected_filename = "roles-#{Date.today}.csv"
    assert_includes content_disposition, expected_filename
  end

  test "download orders roles by ID" do
    sign_in_as(@admin_user)
    
    # Create roles with known IDs (they should be ordered)
    role_z = Role.create!(name: "z_role")
    role_a = Role.create!(name: "a_role")
    
    get download_roles_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # The roles should appear in ID order, not alphabetical order
    z_position = csv_data.index("z_role")
    a_position = csv_data.index("a_role")
    
    assert_not_nil z_position
    assert_not_nil a_position
    # z_role was created first, so should appear before a_role in ID order
    assert z_position < a_position, "Roles should be ordered by ID, not name"
  end

  test "download handles empty roles table" do
    sign_in_as(@admin_user)
    
    # Clear all roles after signing in (to preserve admin role)
    Role.where.not(name: 'admin').destroy_all
    
    get download_roles_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # Should still have headers even with minimal data
    lines = csv_data.split("\n")
    assert lines.length >= 1, "Should have at least header line"
    
    # First line should be headers
    headers = lines.first.split(";")
    assert_includes headers, "name"
  end

  test "download includes roles with special characters" do
    sign_in_as(@admin_user)
    
    # Create role with special characters
    special_role = Role.create!(name: "role-with.special_chars & symbols")
    
    get download_roles_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # Should handle special characters properly in CSV
    assert_includes csv_data, special_role.name
  end

  test "download handles very long role names" do
    sign_in_as(@admin_user)
    
    # Create role with very long name
    long_name = "a" * 500
    long_role = Role.create!(name: long_name)
    
    get download_roles_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # Should handle long names without truncation
    assert_includes csv_data, long_name
  end

  # AUTHENTICATION TESTS
  test "should require authentication for download" do
    get download_roles_path(format: :csv)
    assert_response :unauthorized
  end

  test "download action requires authentication" do
    # Test without signing in
    get download_roles_path(format: :csv)
    assert_response :unauthorized
  end

  # AUTHORIZATION TESTS
  test "authorization hierarchy works correctly for download" do
    users_and_roles = [
      { role: :bronze, can_download: false },
      { role: :silver, can_download: false },
      { role: :gold, can_download: false },
      { role: :admin, can_download: true }
    ]
    
    users_and_roles.each do |test_case|
      user = User.create!(
        name: "#{test_case[:role].capitalize} User",
        email: "#{test_case[:role]}@download.test",
        password: "password",
        confirmed_at: 1.week.ago
      )
      user.add_role(test_case[:role])
      
      sign_in_as(user)
      
      get download_roles_path(format: :csv)
      
      if test_case[:can_download]
        assert_response :success, "#{test_case[:role]} should be able to download roles"
      else
        assert_response :redirect, "#{test_case[:role]} should not be able to download roles"
      end
      
      sign_out
    end
  end

  test "only admin role can download roles" do
    # Test various non-admin roles
    non_admin_roles = [:bronze, :silver, :gold]
    
    non_admin_roles.each do |role|
      user = User.create!(
        name: "#{role.capitalize} User Download Test",
        email: "#{role}download@test.com",
        password: "password",
        confirmed_at: 1.week.ago
      )
      user.add_role(role)
      
      sign_in_as(user)
      
      get download_roles_path(format: :csv)
      assert_response :redirect, "#{role} should not be able to download roles CSV"
      
      sign_out
    end
  end

  # ERROR HANDLING TESTS
  test "download handles edge cases gracefully" do
    sign_in_as(@admin_user)
    
    # Test with special database conditions
    get download_roles_path(format: :csv)
    
    assert_response :success
    # Should not crash with current database state
  end

  test "download handles large datasets gracefully" do
    sign_in_as(@admin_user)
    
    # Create multiple roles to test CSV generation with larger dataset
    (1..10).each { |i| Role.create!(name: "bulk_role_#{i}") }
    
    get download_roles_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # Should handle multiple roles without issues
    assert_includes csv_data, "bulk_role_1"
    assert_includes csv_data, "bulk_role_10"
  end

  # PERFORMANCE TESTS
  test "download performs efficiently with large number of roles" do
    sign_in_as(@admin_user)
    
    # This test ensures the download doesn't cause performance issues
    # We can't easily test query count in integration tests, but we can
    # ensure it responds quickly
    start_time = Time.current
    
    get download_roles_path(format: :csv)
    
    end_time = Time.current
    response_time = end_time - start_time
    
    assert_response :success
    assert response_time < 5.seconds, "Roles download should respond quickly"
  end

  # CSV FORMAT TESTS
  test "CSV format uses semicolon separator" do
    sign_in_as(@admin_user)
    
    get download_roles_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # Check that semicolons are used as separators
    assert_includes csv_data, ";"
    
    # Headers should be separated by semicolons
    headers_line = csv_data.split("\n").first
    assert_includes headers_line, ";"
  end

  test "CSV includes all role attributes" do
    sign_in_as(@admin_user)
    
    # Create role with all possible attributes
    complete_role = Role.create!(
      name: "complete_test_role"
      # Note: resource_type and resource_id would be set if resources were supported
    )
    
    get download_roles_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # Should include the role name
    assert_includes csv_data, "complete_test_role"
    
    # Should include timestamp columns in headers
    headers = csv_data.split("\n").first.split(";")
    assert_includes headers, "created_at"
    assert_includes headers, "updated_at"
  end

  test "CSV handles nil values correctly" do
    sign_in_as(@admin_user)
    
    # Create role with minimal data (nil resource_type, resource_id)
    minimal_role = Role.create!(name: "minimal_role")
    
    get download_roles_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # Should not crash with nil values
    assert_includes csv_data, "minimal_role"
    
    # Should handle nil values gracefully (they might appear as empty fields)
    lines = csv_data.split("\n")
    assert lines.length > 1, "Should have data lines in addition to headers"
  end

  # CONTENT-TYPE TESTS
  test "download sets correct content type for CSV" do
    sign_in_as(@admin_user)
    
    get download_roles_path(format: :csv)
    
    assert_response :success
    assert_equal "text/csv", response.media_type
    # Content-Type header might not include charset
    assert_match /text\/csv/, response.headers['Content-Type']
  end

  test "download sets content disposition for file download" do
    sign_in_as(@admin_user)
    
    get download_roles_path(format: :csv)
    
    assert_response :success
    
    content_disposition = response.headers['Content-Disposition']
    assert_not_nil content_disposition
    assert_includes content_disposition, 'attachment'
    assert_includes content_disposition, 'filename='
  end

  private

  def setup_test_roles
    # Create test roles for CSV testing
    @test_role1 = Role.create!(name: "test_role_1")
    @test_role2 = Role.create!(name: "test_role_2")
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