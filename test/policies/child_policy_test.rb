# frozen_string_literal: true

require 'test_helper'

class ChildPolicyTest < ActiveSupport::TestCase
  def setup
    # Create roles if they don't exist
    Role.find_or_create_by(name: 'admin')
    Role.find_or_create_by(name: 'gold')
    Role.find_or_create_by(name: 'silver')
    Role.find_or_create_by(name: 'bronze')

    @admin_user = users(:one)
    @admin_user.add_role(:admin)

    @gold_user = User.create!(
      name: 'Gold User',
      email: 'gold@example.com',
      password: 'password',
      confirmed_at: 1.week.ago
    )
    @gold_user.add_role(:gold)

    @silver_user = User.create!(
      name: 'Silver User',
      email: 'silver@example.com',
      password: 'password',
      confirmed_at: 1.week.ago
    )
    @silver_user.add_role(:silver)

    @bronze_user = users(:two)
    @bronze_user.add_role(:bronze)

    # Create a test child relationship
    @couple = couples(:one)
    @child = people(:two)
  end

  # INITIALIZATION TESTS
  test 'policy initializes correctly with user and record' do
    policy = ChildPolicy.new(@admin_user, @child)
    assert_equal @admin_user, policy.user
    assert_equal @child, policy.record
  end

  test 'policy ignores second parameter in initialize' do
    # ChildPolicy initializes with (user, _record) - ignoring the record
    policy = ChildPolicy.new(@admin_user, @child)
    assert_equal @admin_user, policy.user
    # The _record parameter is ignored in ChildPolicy
  end

  # INDEX TESTS
  test 'index? allows everyone' do
    policy = ChildPolicy.new(@admin_user, @child)
    assert policy.index?

    policy = ChildPolicy.new(@bronze_user, @child)
    assert policy.index?

    policy = ChildPolicy.new(nil, @child)
    assert policy.index?
  end

  # DOWNLOAD TESTS
  test 'download? allows admin users only' do
    policy = ChildPolicy.new(@admin_user, @child)
    assert policy.download?
  end

  test 'download? denies non-admin users' do
    [@gold_user, @silver_user, @bronze_user].each do |user|
      policy = ChildPolicy.new(user, @child)
      assert_not policy.download?, "#{user.roles.pluck(:name)} should not have download access"
    end
  end

  test 'download? denies unauthenticated users' do
    policy = ChildPolicy.new(nil, @child)
    assert_not policy.download?
  end

  # SHOW TESTS
  test 'show? allows everyone' do
    policy = ChildPolicy.new(@admin_user, @child)
    assert policy.show?

    policy = ChildPolicy.new(@bronze_user, @child)
    assert policy.show?

    policy = ChildPolicy.new(nil, @child)
    assert policy.show?
  end

  # NEW TESTS
  test 'new? allows silver, gold, and admin users' do
    [@silver_user, @gold_user, @admin_user].each do |user|
      policy = ChildPolicy.new(user, @child)
      assert policy.new?, "#{user.roles.pluck(:name)} should have new access"
    end
  end

  test 'new? denies bronze users' do
    policy = ChildPolicy.new(@bronze_user, @child)
    assert_not policy.new?
  end

  test 'new? denies unauthenticated users' do
    policy = ChildPolicy.new(nil, @child)
    assert_not policy.new?
  end

  # EDIT TESTS
  test 'edit? delegates to new?' do
    [@silver_user, @gold_user, @admin_user].each do |user|
      policy = ChildPolicy.new(user, @child)
      assert policy.edit?, "#{user.roles.pluck(:name)} should have edit access"
      assert_equal policy.new?, policy.edit?
    end

    policy = ChildPolicy.new(@bronze_user, @child)
    assert_not policy.edit?
    assert_equal policy.new?, policy.edit?
  end

  # CREATE TESTS
  test 'create? delegates to new?' do
    [@silver_user, @gold_user, @admin_user].each do |user|
      policy = ChildPolicy.new(user, @child)
      assert policy.create?, "#{user.roles.pluck(:name)} should have create access"
      assert_equal policy.new?, policy.create?
    end

    policy = ChildPolicy.new(@bronze_user, @child)
    assert_not policy.create?
    assert_equal policy.new?, policy.create?
  end

  # UPDATE TESTS
  test 'update? delegates to new?' do
    [@silver_user, @gold_user, @admin_user].each do |user|
      policy = ChildPolicy.new(user, @child)
      assert policy.update?, "#{user.roles.pluck(:name)} should have update access"
      assert_equal policy.new?, policy.update?
    end

    policy = ChildPolicy.new(@bronze_user, @child)
    assert_not policy.update?
    assert_equal policy.new?, policy.update?
  end

  # DESTROY TESTS
  test 'destroy? allows gold and admin users only' do
    [@gold_user, @admin_user].each do |user|
      policy = ChildPolicy.new(user, @child)
      assert policy.destroy?, "#{user.roles.pluck(:name)} should have destroy access"
    end
  end

  test 'destroy? denies silver and bronze users' do
    [@silver_user, @bronze_user].each do |user|
      policy = ChildPolicy.new(user, @child)
      assert_not policy.destroy?, "#{user.roles.pluck(:name)} should not have destroy access"
    end
  end

  test 'destroy? denies unauthenticated users' do
    policy = ChildPolicy.new(nil, @child)
    assert_not policy.destroy?
  end

  # ROLE HIERARCHY TESTS
  test 'role hierarchy for creation actions' do
    creation_actions = [:new?, :edit?, :create?, :update?]

    # Admin, Gold, and Silver should have all creation permissions
    [@admin_user, @gold_user, @silver_user].each do |user|
      policy = ChildPolicy.new(user, @child)
      creation_actions.each do |action|
        assert policy.send(action), "#{user.roles.pluck(:name)} should have #{action} access"
      end
    end

    # Bronze should not have creation permissions
    policy = ChildPolicy.new(@bronze_user, @child)
    creation_actions.each do |action|
      assert_not policy.send(action), "Bronze users should not have #{action} access"
    end
  end

  test 'role hierarchy for destruction actions' do
    # Only gold and admin should have destroy permissions
    [@gold_user, @admin_user].each do |user|
      policy = ChildPolicy.new(user, @child)
      assert policy.destroy?, "#{user.roles.pluck(:name)} should have destroy access"
    end

    # Silver and bronze should not have destroy permissions
    [@silver_user, @bronze_user].each do |user|
      policy = ChildPolicy.new(user, @child)
      assert_not policy.destroy?, "#{user.roles.pluck(:name)} should not have destroy access"
    end
  end

  # INHERITANCE TESTS
  test 'inherits from ApplicationPolicy' do
    assert ChildPolicy < ApplicationPolicy
  end

  test 'overrides ApplicationPolicy defaults correctly' do
    policy = ChildPolicy.new(@admin_user, @child)

    # These should be overridden to allow access
    assert policy.index?
    assert policy.show?
    assert policy.new?
    assert policy.create?
    assert policy.update?
    assert policy.destroy?
  end

  test 'policy follows same pattern as PersonPolicy and CouplePolicy' do
    # ChildPolicy should have identical authorization rules to PersonPolicy and CouplePolicy
    person_policy = PersonPolicy.new(@admin_user, people(:one))
    couple_policy = CouplePolicy.new(@admin_user, couples(:one))
    child_policy = ChildPolicy.new(@admin_user, @child)

    # Public access methods
    assert_equal person_policy.index?, child_policy.index?
    assert_equal couple_policy.index?, child_policy.index?
    assert_equal person_policy.show?, child_policy.show?
    assert_equal couple_policy.show?, child_policy.show?

    # Creation methods (require silver+)
    assert_equal person_policy.new?, child_policy.new?
    assert_equal couple_policy.new?, child_policy.new?
    assert_equal person_policy.create?, child_policy.create?
    assert_equal couple_policy.create?, child_policy.create?
    assert_equal person_policy.update?, child_policy.update?
    assert_equal couple_policy.update?, child_policy.update?

    # Destruction methods (require gold+)
    assert_equal person_policy.destroy?, child_policy.destroy?
    assert_equal couple_policy.destroy?, child_policy.destroy?

    # Admin-only methods
    assert_equal person_policy.download?, child_policy.download?
    assert_equal couple_policy.download?, child_policy.download?
  end

  # EDGE CASES
  test 'handles users with multiple roles' do
    multi_role_user = User.create!(
      name: 'Multi Role User',
      email: 'multi@example.com',
      password: 'password',
      confirmed_at: 1.week.ago
    )
    multi_role_user.add_role(:bronze)
    multi_role_user.add_role(:gold)

    policy = ChildPolicy.new(multi_role_user, @child)

    # Should have highest role privileges (gold)
    assert policy.new?
    assert policy.destroy?
  end

  test 'handles user with no roles' do
    no_role_user = User.create!(
      name: 'No Role User',
      email: 'norole@example.com',
      password: 'password',
      confirmed_at: 1.week.ago
    )
    # Don't add any roles

    policy = ChildPolicy.new(no_role_user, @child)

    # Should not have privileged access
    assert_not policy.new?
    assert_not policy.destroy?
    assert_not policy.download?

    # But should still have public access
    assert policy.index?
    assert policy.show?
  end

  test 'policy methods work with different record types' do
    # ChildPolicy ignores the record parameter, so different types shouldn't matter
    policy_with_person = ChildPolicy.new(@admin_user, @child)
    policy_with_couple = ChildPolicy.new(@admin_user, @couple)
    policy_with_nil = ChildPolicy.new(@admin_user, nil)
    policy_with_string = ChildPolicy.new(@admin_user, 'test')

    # All should work the same since record is ignored
    [policy_with_person, policy_with_couple, policy_with_nil, policy_with_string].each do |policy|
      assert policy.index?
      assert policy.show?
      assert policy.new?
      assert policy.destroy?
    end
  end

  test 'nil record handling' do
    policy = ChildPolicy.new(@admin_user, nil)

    # Should not crash and should still check user permissions
    assert policy.index?
    assert policy.new?
    assert policy.destroy?
  end

  test 'all policy methods are defined' do
    policy = ChildPolicy.new(@admin_user, @child)
    expected_methods = [
      :index?, :download?, :show?, :new?, :edit?, :create?,
      :update?, :destroy?
    ]

    expected_methods.each do |method|
      assert_respond_to policy, method, "Policy should respond to #{method}"
    end
  end

  test 'has_any_role usage works correctly' do
    # Test that has_any_role? correctly identifies users with any of the specified roles

    # Silver user should pass silver/gold/admin check
    policy = ChildPolicy.new(@silver_user, @child)
    assert policy.new? # Uses has_any_role? :silver, :gold, :admin

    # Gold user should pass gold/admin check  
    policy = ChildPolicy.new(@gold_user, @child)
    assert policy.destroy? # Uses has_any_role? :gold, :admin

    # Bronze user should fail both checks
    policy = ChildPolicy.new(@bronze_user, @child)
    assert_not policy.new? # Should fail silver/gold/admin check
    assert_not policy.destroy? # Should fail gold/admin check
  end

  test 'policy is consistent regardless of record' do
    # Since ChildPolicy ignores the record parameter, it should be consistent
    policy1 = ChildPolicy.new(@silver_user, @child)
    policy2 = ChildPolicy.new(@silver_user, @couple)
    policy3 = ChildPolicy.new(@silver_user, nil)

    # All permissions should be the same since record is ignored
    assert_equal policy1.show?, policy2.show?
    assert_equal policy1.show?, policy3.show?
    assert_equal policy1.new?, policy2.new?
    assert_equal policy1.new?, policy3.new?
    assert_equal policy1.destroy?, policy2.destroy?
    assert_equal policy1.destroy?, policy3.destroy?
  end

  test 'policy uses user attribute correctly' do
    policy = ChildPolicy.new(@admin_user, @child)

    # The policy should store the user correctly
    assert_equal @admin_user, policy.user

    # And use it for authorization checks
    assert policy.download? # Admin should have download access

    # Test with different user
    bronze_policy = ChildPolicy.new(@bronze_user, @child)
    assert_equal @bronze_user, bronze_policy.user
    assert_not bronze_policy.download? # Bronze should not have download access
  end
end
