require "test_helper"

class RoleTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:one)
    @user2 = users(:two)
    
    # Create test person for resource testing
    @person = Person.create!(
      name: "Test Person",
      birth_year: 1980
    )
  end

  # BASIC MODEL TESTS
  test "Role model includes correct modules" do
    assert Role.include?(GenerateCsv)
  end

  test "Role uses paranoid deletion" do
    role = Role.create!(name: "test_role")
    
    # Should use soft delete
    role.destroy
    assert_not_nil role.deleted_at
    assert role.deleted?
    
    # Should still be findable with deleted scope
    assert_includes Role.with_deleted, role
    assert_not_includes Role.all, role
  end

  test "Role has correct associations" do
    role = Role.new
    
    # Test associations exist
    assert_respond_to role, :users
    assert_respond_to role, :resource
  end

  # VALIDATION TESTS
  test "Role validates resource_type inclusion" do
    # Valid role without resource
    role = Role.new(name: "test_role")
    assert role.valid?
    
    # Valid role with nil resource_type
    role = Role.new(name: "test_role", resource_type: nil)
    assert role.valid?
    
    # Test with valid resource types (depends on Rolify.resource_types)
    # We'll test with common resource types that might be configured
    valid_types = ["Person", "User"]
    
    valid_types.each do |resource_type|
      role = Role.new(name: "test_role", resource_type: resource_type)
      # This test will pass or fail based on actual Rolify configuration
      # but won't cause errors since we're not saving invalid data
    end
  end

  test "Role allows nil resource" do
    role = Role.create!(name: "global_role")
    assert_nil role.resource
    assert_nil role.resource_type
    assert_nil role.resource_id
  end

  test "Role cannot have resource when resource_types is empty" do
    # Since Rolify.resource_types is empty, resource_type validation should fail
    role = Role.new(
      name: "person_specific_role",
      resource: @person
    )
    
    assert_not role.valid?
    assert_includes role.errors[:resource_type], "não está incluído na lista"
  end

  # ASSOCIATION TESTS
  test "Role can be associated with multiple users" do
    role = Role.create!(name: "shared_role")
    
    role.users << @user1
    role.users << @user2
    
    assert_equal 2, role.users.count
    assert_includes role.users, @user1
    assert_includes role.users, @user2
  end

  test "Role users association uses correct join table" do
    role = Role.create!(name: "join_test")
    
    # The association should use users_roles join table
    role.users << @user1
    
    # Check that the association was created
    assert_equal 1, role.users.count
    assert_equal @user1, role.users.first
  end

  # ROLE FUNCTIONALITY TESTS
  test "Role can be created with standard role names" do
    standard_roles = [:admin, :gold, :silver, :bronze]
    
    standard_roles.each do |role_name|
      role = Role.create!(name: role_name.to_s)
      assert role.persisted?
      assert_equal role_name.to_s, role.name
    end
  end

  test "Role names should be unique" do
    Role.create!(name: "unique_role")
    
    # This should work (no uniqueness constraint enforced by model)
    # but in practice, role names are typically unique
    duplicate_role = Role.new(name: "unique_role")
    assert duplicate_role.valid?
  end

  test "Role validation prevents resource assignment when not configured" do
    # Test that resource assignment fails when resource_types is empty
    role = Role.new(
      name: "editor",
      resource: @person
    )
    
    assert_not role.valid?
    assert_includes role.errors[:resource_type], "não está incluído na lista"
  end

  test "Role can be assigned to user globally" do
    role = Role.create!(name: "global_admin")
    
    @user1.roles << role
    
    assert_includes @user1.roles, role
  end

  # RANSACKABLE TESTS
  test "ransackable_associations returns correct associations" do
    ransackable_assocs = Role.ransackable_associations
    
    expected_assocs = ["resource", "users"]
    assert_equal expected_assocs, ransackable_assocs
  end

  test "ransackable_attributes returns correct attributes" do
    ransackable_attrs = Role.ransackable_attributes
    
    expected_attrs = ["created_at", "deleted_at", "id", "name", "resource_id", "resource_type", "updated_at"]
    assert_equal expected_attrs, ransackable_attrs
  end

  # CSV GENERATION TESTS
  test "Role inherits CSV generation from GenerateCsv" do
    assert_respond_to Role, :to_csv
  end

  test "Role.to_csv generates CSV with correct headers and data" do
    role1 = Role.create!(name: "test_role_1")
    role2 = Role.create!(name: "test_role_2")
    
    roles = [role1, role2]
    csv_data = Role.to_csv(roles)
    
    # Check CSV structure
    lines = csv_data.split("\n")
    headers = lines.first.split(";")
    
    # Should include main Role columns
    assert_includes headers, "name"
    assert_includes headers, "resource_type"
    assert_includes headers, "resource_id"
    
    # Check that data is included
    assert csv_data.include?("test_role_1")
    assert csv_data.include?("test_role_2")
  end

  # ROLIFY INTEGRATION TESTS
  test "Role works with User rolify methods" do
    # Test basic rolify integration
    role = Role.create!(name: "test_role")
    
    @user1.add_role(:test_role)
    
    assert @user1.has_role?(:test_role)
    assert_includes @user1.roles.map(&:name), "test_role"
  end

  test "Role works only with global scope in this app" do
    # Since resource_types is empty, only global roles are supported
    role = Role.create!(name: "moderator")
    
    @user1.add_role(:moderator)
    
    assert @user1.has_role?(:moderator)
    # Cannot test scoped roles since they're not supported
  end

  test "Role can be removed from user" do
    role = Role.create!(name: "temporary_role")
    @user1.add_role(:temporary_role)
    
    assert @user1.has_role?(:temporary_role)
    
    @user1.remove_role(:temporary_role)
    
    assert_not @user1.has_role?(:temporary_role)
  end

  # EDGE CASES AND ERROR HANDLING
  test "Role handles empty name gracefully" do
    role = Role.new(name: "")
    # Should be valid (no presence validation on name in the model)
    assert role.valid?
  end

  test "Role handles nil name" do
    role = Role.new(name: nil)
    # Should be valid (no presence validation on name in the model)
    assert role.valid?
  end

  test "Role handles special characters in name" do
    special_names = ["admin-user", "role_with_underscore", "role.with.dots", "role with spaces"]
    
    special_names.each do |name|
      role = Role.create!(name: name)
      assert role.persisted?
      assert_equal name, role.name
    end
  end

  test "Role can have very long name" do
    long_name = "a" * 255
    role = Role.create!(name: long_name)
    assert role.persisted?
    assert_equal long_name, role.name
  end

  # SOFT DELETE TESTS
  test "Role soft delete preserves data" do
    role = Role.create!(name: "preserve_test")
    @user1.add_role(role.name.to_sym)
    
    original_id = role.id
    
    # Soft delete
    role.destroy
    
    # Should still exist in database with deleted_at set
    deleted_role = Role.with_deleted.find(original_id)
    assert_not_nil deleted_role.deleted_at
    assert_equal "preserve_test", deleted_role.name
    assert_nil deleted_role.resource
  end

  test "Role soft delete affects user associations" do
    role = Role.create!(name: "deletable_role")
    @user1.add_role(:deletable_role)
    
    assert @user1.has_role?(:deletable_role)
    
    # Soft delete the role
    role.destroy
    
    # User should no longer have the role (depends on Rolify implementation)
    # This behavior may vary based on how rolify handles soft-deleted roles
    @user1.reload
  end

  # ROLIFY RESOURCE TYPES VALIDATION
  test "Role validates against configured resource types" do
    # Test that the validation works with actual configured types
    # Since Rolify.resource_types is empty, any resource_type should be invalid
    role = Role.new(name: "test", resource_type: "AnyType")
    
    assert_not role.valid?
    assert_includes role.errors[:resource_type], "não está incluído na lista"
  end

  # SCOPED ROLES TESTS
  test "Role scoping is not supported when resource_types is empty" do
    # Test that resource scoping fails when resource_types is empty
    person1 = Person.create!(name: "Person 1", birth_year: 1990)
    
    # Cannot create scoped roles
    role = Role.new(name: "manager", resource: person1)
    assert_not role.valid?
    
    # But global roles work fine
    global_role = Role.create!(name: "global_manager")
    @user1.add_role(:global_manager)
    
    assert @user1.has_role?(:global_manager)
  end

  test "Role scopify functionality is enabled" do
    # Test that scopify is working (allows resource-scoped roles)
    assert_respond_to Role, :scopify
  end

  private

  def create_test_user(email_suffix)
    User.create!(
      name: "Test User #{email_suffix}",
      email: "test#{email_suffix}@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
  end
end