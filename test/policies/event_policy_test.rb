require 'test_helper'

class EventPolicyTest < ActiveSupport::TestCase
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
    
    # Create a test event
    @person = people(:one)
    @event = Event.create!(
      name: "Test Event",
      user: @admin_user,
      resource: @person,
      data: { test: "data" }
    )
  end

  # INITIALIZATION TESTS
  test "policy initializes correctly with user and event" do
    policy = EventPolicy.new(@admin_user, @event)
    assert_equal @admin_user, policy.user
    assert_equal @event, policy.record
  end

  # DOWNLOAD TESTS
  test "download? allows admin users only" do
    policy = EventPolicy.new(@admin_user, @event)
    assert policy.download?
  end

  test "download? denies non-admin users" do
    [@gold_user, @silver_user, @bronze_user].each do |user|
      policy = EventPolicy.new(user, @event)
      assert_not policy.download?, "#{user.roles.pluck(:name)} should not have download access"
    end
  end

  test "download? denies unauthenticated users" do
    policy = EventPolicy.new(nil, @event)
    assert_not policy.download?
  end

  # DEFAULT BEHAVIOR TESTS (inherited from ApplicationPolicy)
  test "inherits ApplicationPolicy defaults for non-overridden methods" do
    policy = EventPolicy.new(@admin_user, @event)
    
    # EventPolicy only overrides download?, all others should use ApplicationPolicy defaults
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
      policy = EventPolicy.new(user, @event)
      
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
    policy = EventPolicy.new(nil, @event)
    
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
    assert EventPolicy < ApplicationPolicy
  end

  test "only overrides download? method" do
    # EventPolicy should only define download?, all others inherited
    event_methods = EventPolicy.instance_methods(false)
    assert_includes event_methods, :download?
    
    # Should not override other methods
    application_methods = [:index?, :show?, :create?, :new?, :update?, :edit?, :destroy?]
    application_methods.each do |method|
      assert_not_includes event_methods, method, "EventPolicy should not override #{method}"
    end
  end

  # ROLE HIERARCHY TESTS
  test "admin role provides download access" do
    policy = EventPolicy.new(@admin_user, @event)
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
      
      policy = EventPolicy.new(user, @event)
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
    
    policy = EventPolicy.new(multi_role_user, @event)
    
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
    
    policy = EventPolicy.new(no_role_user, @event)
    
    # Should not have any access
    assert_not policy.download?
    assert_not policy.index?
    assert_not policy.show?
    assert_not policy.create?
    assert_not policy.destroy?
  end

  test "policy methods work with different record types" do
    # Test with different record types
    policy_with_event = EventPolicy.new(@admin_user, @event)
    policy_with_class = EventPolicy.new(@admin_user, Event)
    policy_with_nil = EventPolicy.new(@admin_user, nil)
    
    # Admin should have download access regardless of record type
    assert policy_with_event.download?
    assert policy_with_class.download?
    assert policy_with_nil.download?
    
    # Non-admin should not have access regardless of record type
    [@gold_user, @silver_user, @bronze_user].each do |user|
      policy_with_event = EventPolicy.new(user, @event)
      policy_with_class = EventPolicy.new(user, Event)
      policy_with_nil = EventPolicy.new(user, nil)
      
      assert_not policy_with_event.download?
      assert_not policy_with_class.download?
      assert_not policy_with_nil.download?
    end
  end

  test "nil record handling" do
    policy = EventPolicy.new(@admin_user, nil)
    
    # Should not crash and should still check user permissions
    assert policy.download?
    
    # Should still deny default actions
    assert_not policy.index?
    assert_not policy.show?
    assert_not policy.create?
  end

  test "all expected policy methods are defined" do
    policy = EventPolicy.new(@admin_user, @event)
    expected_methods = [
      :index?, :show?, :create?, :new?, :update?, :edit?, :destroy?, :download?
    ]
    
    expected_methods.each do |method|
      assert_respond_to policy, method, "Policy should respond to #{method}"
    end
  end

  test "delegation methods work correctly" do
    policy = EventPolicy.new(@admin_user, @event)
    
    # Test that inherited delegation still works
    assert_equal policy.create?, policy.new?
    assert_equal policy.update?, policy.edit?
  end

  test "policy maintains consistent behavior" do
    # EventPolicy should behave consistently across different instances
    event1 = @event
    event2 = Event.create!(
      name: "Another Event",
      user: @bronze_user,
      resource: @person,
      data: { test: "data2" }
    )
    
    admin_policy1 = EventPolicy.new(@admin_user, event1)
    admin_policy2 = EventPolicy.new(@admin_user, event2)
    
    # Admin should have same permissions regardless of event
    assert_equal admin_policy1.download?, admin_policy2.download?
    assert_equal admin_policy1.index?, admin_policy2.index?
    assert_equal admin_policy1.show?, admin_policy2.show?
    
    bronze_policy1 = EventPolicy.new(@bronze_user, event1)
    bronze_policy2 = EventPolicy.new(@bronze_user, event2)
    
    # Bronze should have same (lack of) permissions regardless of event
    assert_equal bronze_policy1.download?, bronze_policy2.download?
    assert_equal bronze_policy1.index?, bronze_policy2.index?
    assert_equal bronze_policy1.show?, bronze_policy2.show?
  end

  test "comparison with other policies shows distinct behavior" do
    # EventPolicy should be more restrictive than PersonPolicy, CouplePolicy, ChildPolicy
    event_policy = EventPolicy.new(@silver_user, @event)
    person_policy = PersonPolicy.new(@silver_user, @person)
    
    # Silver user should have different access patterns
    # EventPolicy: restrictive (only admin can download, others denied everything)
    assert_not event_policy.index?
    assert_not event_policy.show?
    assert_not event_policy.create?
    assert_not event_policy.download?
    
    # PersonPolicy: more permissive (public access to some actions)
    assert person_policy.index?
    assert person_policy.show?
    assert person_policy.create? # Silver can create persons
    assert_not person_policy.download? # But not download
  end

  test "has_role? method works correctly for admin check" do
    # Test that the admin check in download? works correctly
    admin_policy = EventPolicy.new(@admin_user, @event)
    assert @admin_user.has_role?(:admin)
    assert admin_policy.download?
    
    bronze_policy = EventPolicy.new(@bronze_user, @event)
    assert_not @bronze_user.has_role?(:admin)
    assert_not bronze_policy.download?
  end
end