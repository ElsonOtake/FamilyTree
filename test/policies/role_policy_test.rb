require 'test_helper'

class RolePolicyTest < ActiveSupport::TestCase
  def setup
    # Create roles if they don't exist
    Role.find_or_create_by(name: 'admin')
    Role.find_or_create_by(name: 'gold')
    Role.find_or_create_by(name: 'silver')
    Role.find_or_create_by(name: 'bronze')

    @admin_user = users(:one)
    @admin_user.add_role(:admin)
    
    @gold_user = User.create!(
      name: "Gold User",
      email: "gold@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    @gold_user.add_role(:gold)
    
    @silver_user = User.create!(
      name: "Silver User",
      email: "silver@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    @silver_user.add_role(:silver)
    
    @bronze_user = users(:two)
    @bronze_user.add_role(:bronze)
    
    @admin_role = Role.find_by(name: 'admin')
    @gold_role = Role.find_by(name: 'gold')
  end

  # INITIALIZATION TESTS
  test "policy initializes correctly with user and role" do
    policy = RolePolicy.new(@admin_user, @admin_role)
    assert_equal @admin_user, policy.user
    assert_equal @admin_role, policy.record
  end

  # DOWNLOAD TESTS
  test "download? allows admin users only" do
    policy = RolePolicy.new(@admin_user, @admin_role)
    assert policy.download?
  end

  test "download? denies non-admin users" do
    [@gold_user, @silver_user, @bronze_user].each do |user|
      policy = RolePolicy.new(user, @admin_role)
      assert_not policy.download?, "#{user.roles.pluck(:name)} should not have download access"
    end
  end

  test "download? denies unauthenticated users" do
    policy = RolePolicy.new(nil, @admin_role)
    assert_not policy.download?
  end

  # DEFAULT BEHAVIOR TESTS (inherited from ApplicationPolicy)
  test "inherits ApplicationPolicy defaults for non-overridden methods" do
    policy = RolePolicy.new(@admin_user, @admin_role)
    
    # RolePolicy only overrides download?, all others should use ApplicationPolicy defaults
    assert_not policy.index?
    assert_not policy.show?
    assert_not policy.create?
    assert_not policy.new?
    assert_not policy.update?
    assert_not policy.edit?
    assert_not policy.destroy?
  end

  test "non-admin users are denied all default actions" do
    [@gold_user, @silver_user, @bronze_user].each do |user|
      policy = RolePolicy.new(user, @admin_role)
      
      # All default actions should be denied for non-admin users
      assert_not policy.index?, "#{user.roles.pluck(:name)} should not have index access"
      assert_not policy.show?, "#{user.roles.pluck(:name)} should not have show access"
      assert_not policy.create?, "#{user.roles.pluck(:name)} should not have create access"
      assert_not policy.new?, "#{user.roles.pluck(:name)} should not have new access"
      assert_not policy.update?, "#{user.roles.pluck(:name)} should not have update access"
      assert_not policy.edit?, "#{user.roles.pluck(:name)} should not have edit access"
      assert_not policy.destroy?, "#{user.roles.pluck(:name)} should not have destroy access"
    end
  end

  test "unauthenticated users are denied all actions" do
    policy = RolePolicy.new(nil, @admin_role)
    
    # All actions should be denied for unauthenticated users
    assert_not policy.index?
    assert_not policy.show?
    assert_not policy.create?
    assert_not policy.new?
    assert_not policy.update?
    assert_not policy.edit?
    assert_not policy.destroy?
    assert_not policy.download?
  end

  # INHERITANCE TESTS
  test "inherits from ApplicationPolicy" do
    assert RolePolicy < ApplicationPolicy
  end

  test "only overrides download? method" do
    # RolePolicy should only define download?, all others inherited
    role_methods = RolePolicy.instance_methods(false)
    assert_includes role_methods, :download?
    
    # Should not override other methods
    application_methods = [:index?, :show?, :create?, :new?, :update?, :edit?, :destroy?]
    application_methods.each do |method|
      assert_not_includes role_methods, method, "RolePolicy should not override #{method}"
    end
  end

  test "follows same pattern as EventPolicy" do
    # RolePolicy and EventPolicy should have identical behavior (admin-only download)
    event_policy = EventPolicy.new(@admin_user, Event.new)
    role_policy = RolePolicy.new(@admin_user, @admin_role)
    
    # Should have same download permissions
    assert_equal event_policy.download?, role_policy.download?
    
    # Should have same default denials
    assert_equal event_policy.index?, role_policy.index?
    assert_equal event_policy.show?, role_policy.show?
    assert_equal event_policy.create?, role_policy.create?
    assert_equal event_policy.destroy?, role_policy.destroy?
  end

  # ROLE HIERARCHY TESTS
  test "admin role provides download access" do
    policy = RolePolicy.new(@admin_user, @admin_role)
    assert policy.download?
  end

  test "non-admin roles are denied download access" do
    [:gold, :silver, :bronze].each do |role_name|
      user = User.create!(
        name: "#{role_name.capitalize} User Test",
        email: "#{role_name}test@example.com",
        password: "password",
        confirmed_at: 1.week.ago
      )
      user.add_role(role_name)
      
      policy = RolePolicy.new(user, @admin_role)
      assert_not policy.download?, "#{role_name} should not have download access"
    end
  end

  # EDGE CASES
  test "handles users with multiple roles" do
    multi_role_user = User.create!(
      name: "Multi Role User",
      email: "multi@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    multi_role_user.add_role(:bronze)
    multi_role_user.add_role(:admin)
    
    policy = RolePolicy.new(multi_role_user, @admin_role)
    
    # Should have admin access since user has admin role
    assert policy.download?
  end

  test "handles user with no roles" do
    no_role_user = User.create!(
      name: "No Role User",
      email: "norole@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    # Don't add any roles
    
    policy = RolePolicy.new(no_role_user, @admin_role)
    
    # Should not have any access
    assert_not policy.download?
    assert_not policy.index?
    assert_not policy.show?
    assert_not policy.create?
    assert_not policy.destroy?
  end

  test "policy methods work with different role records" do
    # Test with different role types
    [@admin_role, @gold_role].each do |role|
      admin_policy = RolePolicy.new(@admin_user, role)
      bronze_policy = RolePolicy.new(@bronze_user, role)
      
      # Admin should have download access regardless of which role record
      assert admin_policy.download?, "Admin should have download access for #{role.name} role"
      
      # Non-admin should not have access regardless of which role record
      assert_not bronze_policy.download?, "Bronze should not have download access for #{role.name} role"
    end
  end

  test "policy methods work with Role class vs instance" do
    # Test with class vs instance
    class_policy = RolePolicy.new(@admin_user, Role)
    instance_policy = RolePolicy.new(@admin_user, @admin_role)
    
    # Both should work for admin user
    assert class_policy.download?
    assert instance_policy.download?
    
    # Both should deny for non-admin
    class_policy_bronze = RolePolicy.new(@bronze_user, Role)
    instance_policy_bronze = RolePolicy.new(@bronze_user, @admin_role)
    
    assert_not class_policy_bronze.download?
    assert_not instance_policy_bronze.download?
  end

  test "nil record handling" do
    policy = RolePolicy.new(@admin_user, nil)
    
    # Should not crash and should still check user permissions
    assert policy.download?
    
    # Should still deny default actions
    assert_not policy.index?
    assert_not policy.show?
    assert_not policy.create?
  end

  test "all expected policy methods are defined" do
    policy = RolePolicy.new(@admin_user, @admin_role)
    expected_methods = [
      :index?, :show?, :create?, :new?, :update?, :edit?, :destroy?, :download?
    ]
    
    expected_methods.each do |method|
      assert_respond_to policy, method, "Policy should respond to #{method}"
    end
  end

  test "delegation methods work correctly" do
    policy = RolePolicy.new(@admin_user, @admin_role)
    
    # Test that inherited delegation still works
    assert_equal policy.create?, policy.new?
    assert_equal policy.update?, policy.edit?
  end

  test "policy maintains consistent behavior across role instances" do
    # RolePolicy should behave consistently across different role instances
    bronze_role = Role.find_by(name: 'bronze')
    silver_role = Role.find_by(name: 'silver')
    
    admin_policy_bronze = RolePolicy.new(@admin_user, bronze_role)
    admin_policy_silver = RolePolicy.new(@admin_user, silver_role)
    admin_policy_gold = RolePolicy.new(@admin_user, @gold_role)
    
    # Admin should have same permissions regardless of role record
    assert_equal admin_policy_bronze.download?, admin_policy_silver.download?
    assert_equal admin_policy_silver.download?, admin_policy_gold.download?
    assert_equal admin_policy_bronze.index?, admin_policy_silver.index?
    assert_equal admin_policy_silver.index?, admin_policy_gold.index?
    
    bronze_policy_bronze = RolePolicy.new(@bronze_user, bronze_role)
    bronze_policy_silver = RolePolicy.new(@bronze_user, silver_role)
    bronze_policy_gold = RolePolicy.new(@bronze_user, @gold_role)
    
    # Bronze should have same (lack of) permissions regardless of role record
    assert_equal bronze_policy_bronze.download?, bronze_policy_silver.download?
    assert_equal bronze_policy_silver.download?, bronze_policy_gold.download?
    assert_equal bronze_policy_bronze.index?, bronze_policy_silver.index?
    assert_equal bronze_policy_silver.index?, bronze_policy_gold.index?
  end

  test "comparison with other policies shows appropriate behavior" do
    # RolePolicy should be restrictive like EventPolicy
    role_policy = RolePolicy.new(@silver_user, @admin_role)
    event_policy = EventPolicy.new(@silver_user, Event.new)
    person_policy = PersonPolicy.new(@silver_user, people(:one))
    
    # RolePolicy and EventPolicy should be equally restrictive
    assert_equal role_policy.index?, event_policy.index?
    assert_equal role_policy.show?, event_policy.show?
    assert_equal role_policy.create?, event_policy.create?
    assert_equal role_policy.download?, event_policy.download?
    
    # PersonPolicy should be more permissive
    assert_not role_policy.index?
    assert person_policy.index?
    assert_not role_policy.show?
    assert person_policy.show?
    assert_not role_policy.create?
    assert person_policy.create? # Silver can create persons
  end

  test "has_role? method works correctly for admin check" do
    # Test that the admin check in download? works correctly
    admin_policy = RolePolicy.new(@admin_user, @admin_role)
    assert @admin_user.has_role?(:admin)
    assert admin_policy.download?
    
    bronze_policy = RolePolicy.new(@bronze_user, @admin_role)
    assert_not @bronze_user.has_role?(:admin)
    assert_not bronze_policy.download?
  end

  test "policy works with all role types in system" do
    # Test that policy works consistently with all role types
    all_roles = Role.all
    
    all_roles.each do |role|
      admin_policy = RolePolicy.new(@admin_user, role)
      gold_policy = RolePolicy.new(@gold_user, role)
      
      assert admin_policy.download?, "Admin should have download access for #{role.name}"
      assert_not gold_policy.download?, "Gold should not have download access for #{role.name}"
      
      assert_not admin_policy.index?, "All roles should deny index for #{role.name}"
      assert_not gold_policy.index?, "All roles should deny index for #{role.name}"
    end
  end
end