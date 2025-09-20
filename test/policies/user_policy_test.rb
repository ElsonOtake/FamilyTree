require 'test_helper'

class UserPolicyTest < ActiveSupport::TestCase
  def setup
    # Create roles if they don't exist
    Role.find_or_create_by(name: 'admin')
    Role.find_or_create_by(name: 'gold')
    Role.find_or_create_by(name: 'silver')
    Role.find_or_create_by(name: 'bronze')

    @admin_user = users(:one)
    @admin_user.add_role(:admin)
    
    @bronze_user = users(:two)
    @bronze_user.add_role(:bronze)
    
    @target_user = User.create!(
      name: "Target User",
      email: "target@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    @target_user.add_role(:bronze)
  end

  # INITIALIZATION TESTS
  test "policy initializes correctly with user and record" do
    policy = UserPolicy.new(@admin_user, @target_user)
    assert_equal @admin_user, policy.user
    assert_equal @target_user, policy.record
  end

  # INDEX TESTS
  test "index? allows admin users" do
    policy = UserPolicy.new(@admin_user, User)
    assert policy.index?
  end

  test "index? denies non-admin users" do
    policy = UserPolicy.new(@bronze_user, User)
    assert_not policy.index?
  end

  test "index? denies unauthenticated users" do
    policy = UserPolicy.new(nil, User)
    assert_not policy.index?
  end

  # ROLES TESTS
  test "roles? allows admin users" do
    policy = UserPolicy.new(@admin_user, User)
    assert policy.roles?
  end

  test "roles? denies non-admin users" do
    policy = UserPolicy.new(@bronze_user, User)
    assert_not policy.roles?
  end

  test "roles? denies unauthenticated users" do
    policy = UserPolicy.new(nil, User)
    assert_not policy.roles?
  end

  # ROLE_UPDATE TESTS
  test "role_update? allows admin users" do
    policy = UserPolicy.new(@admin_user, @target_user)
    assert policy.role_update?
  end

  test "role_update? denies non-admin users" do
    policy = UserPolicy.new(@bronze_user, @target_user)
    assert_not policy.role_update?
  end

  test "role_update? denies unauthenticated users" do
    policy = UserPolicy.new(nil, @target_user)
    assert_not policy.role_update?
  end

  # CHANGE TESTS
  test "change? allows any authenticated user" do
    policy = UserPolicy.new(@admin_user, @target_user)
    assert policy.change?
    
    policy = UserPolicy.new(@bronze_user, @target_user)
    assert policy.change?
  end

  test "change? allows unauthenticated users" do
    # This is intentionally true for locale changes
    policy = UserPolicy.new(nil, @target_user)
    assert policy.change?
  end

  # CHANGE_UNIDENTIFIED TESTS
  test "change_unidentified? allows any user" do
    policy = UserPolicy.new(@admin_user, User)
    assert policy.change_unidentified?
    
    policy = UserPolicy.new(@bronze_user, User)
    assert policy.change_unidentified?
  end

  test "change_unidentified? allows unauthenticated users" do
    policy = UserPolicy.new(nil, User)
    assert policy.change_unidentified?
  end

  # DOWNLOAD TESTS
  test "download? allows admin users" do
    policy = UserPolicy.new(@admin_user, User)
    assert policy.download?
  end

  test "download? denies non-admin users" do
    policy = UserPolicy.new(@bronze_user, User)
    assert_not policy.download?
  end

  test "download? denies unauthenticated users" do
    policy = UserPolicy.new(nil, User)
    assert_not policy.download?
  end

  # ROLE HIERARCHY TESTS
  test "admin role provides access to all admin-only actions" do
    admin_actions = [:index?, :roles?, :role_update?, :download?]
    policy = UserPolicy.new(@admin_user, @target_user)
    
    admin_actions.each do |action|
      assert policy.send(action), "Admin should have access to #{action}"
    end
  end

  test "non-admin roles are denied admin-only actions" do
    [:gold, :silver, :bronze].each do |role_name|
      user = User.create!(
        name: "#{role_name.capitalize} User",
        email: "#{role_name}@example.com",
        password: "password",
        confirmed_at: 1.week.ago
      )
      user.add_role(role_name)
      
      admin_actions = [:index?, :roles?, :role_update?, :download?]
      policy = UserPolicy.new(user, @target_user)
      
      admin_actions.each do |action|
        assert_not policy.send(action), "#{role_name} should not have access to #{action}"
      end
    end
  end

  # INHERITANCE TESTS
  test "inherits from ApplicationPolicy" do
    assert UserPolicy < ApplicationPolicy
  end

  test "overrides ApplicationPolicy defaults correctly" do
    policy = UserPolicy.new(@admin_user, @target_user)
    
    # These should be overridden and allow access for admin
    assert policy.index?
    assert policy.download?
    
    # These should still use ApplicationPolicy defaults (deny)
    # UserPolicy doesn't override these
    assert_not policy.show?
    assert_not policy.create?
    assert_not policy.update?
    assert_not policy.destroy?
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
    
    policy = UserPolicy.new(multi_role_user, @target_user)
    
    # Should have admin access since user has admin role
    assert policy.index?
    assert policy.roles?
    assert policy.role_update?
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
    
    policy = UserPolicy.new(no_role_user, @target_user)
    
    # Should not have admin access
    assert_not policy.index?
    assert_not policy.roles?
    assert_not policy.role_update?
    assert_not policy.download?
    
    # But should still have access to public actions
    assert policy.change?
    assert policy.change_unidentified?
  end

  test "policy methods work with different record types" do
    # Test with class vs instance
    class_policy = UserPolicy.new(@admin_user, User)
    instance_policy = UserPolicy.new(@admin_user, @target_user)
    
    # Both should work for admin-only actions
    assert class_policy.index?
    assert instance_policy.index?
    
    assert class_policy.download?
    assert instance_policy.download?
  end

  test "nil record handling" do
    policy = UserPolicy.new(@admin_user, nil)
    
    # Should not crash and should still check user permissions
    assert policy.index?
    assert policy.download?
    assert policy.change?
  end
end
