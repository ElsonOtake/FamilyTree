# frozen_string_literal: true

require 'test_helper'

class PersonPolicyTest < ActiveSupport::TestCase
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

    @person = people(:one)
  end

  # INITIALIZATION TESTS
  test 'policy initializes correctly with user and person' do
    policy = PersonPolicy.new(@admin_user, @person)
    assert_equal @admin_user, policy.user
    assert_equal @person, policy.record
  end

  test 'policy custom attribute readers work' do
    policy = PersonPolicy.new(@admin_user, @person)
    assert_equal @admin_user, policy.user
    # The policy assigns @person but doesn't have attr_reader for it
    # The record is still accessible via inherited record attr_reader
    assert_equal @person, policy.record
  end

  # INDEX TESTS
  test 'index? allows everyone' do
    policy = PersonPolicy.new(@admin_user, Person)
    assert policy.index?

    policy = PersonPolicy.new(@bronze_user, Person)
    assert policy.index?

    policy = PersonPolicy.new(nil, Person)
    assert policy.index?
  end

  # DOWNLOAD TESTS
  test 'download? allows admin users only' do
    policy = PersonPolicy.new(@admin_user, Person)
    assert policy.download?
  end

  test 'download? denies non-admin users' do
    [@gold_user, @silver_user, @bronze_user].each do |user|
      policy = PersonPolicy.new(user, Person)
      assert_not policy.download?, "#{user.roles.pluck(:name)} should not have download access"
    end
  end

  test 'download? denies unauthenticated users' do
    policy = PersonPolicy.new(nil, Person)
    assert_not policy.download?
  end

  # SHOW TESTS
  test 'show? allows everyone' do
    policy = PersonPolicy.new(@admin_user, @person)
    assert policy.show?

    policy = PersonPolicy.new(@bronze_user, @person)
    assert policy.show?

    policy = PersonPolicy.new(nil, @person)
    assert policy.show?
  end

  # NEW TESTS
  test 'new? allows silver, gold, and admin users' do
    [@silver_user, @gold_user, @admin_user].each do |user|
      policy = PersonPolicy.new(user, Person)
      assert policy.new?, "#{user.roles.pluck(:name)} should have new access"
    end
  end

  test 'new? denies bronze users' do
    policy = PersonPolicy.new(@bronze_user, Person)
    assert_not policy.new?
  end

  test 'new? denies unauthenticated users' do
    policy = PersonPolicy.new(nil, Person)
    assert_not policy.new?
  end

  # EDIT TESTS
  test 'edit? delegates to new?' do
    [@silver_user, @gold_user, @admin_user].each do |user|
      policy = PersonPolicy.new(user, @person)
      assert policy.edit?, "#{user.roles.pluck(:name)} should have edit access"
      assert_equal policy.new?, policy.edit?
    end

    policy = PersonPolicy.new(@bronze_user, @person)
    assert_not policy.edit?
    assert_equal policy.new?, policy.edit?
  end

  # CREATE TESTS
  test 'create? delegates to new?' do
    [@silver_user, @gold_user, @admin_user].each do |user|
      policy = PersonPolicy.new(user, Person)
      assert policy.create?, "#{user.roles.pluck(:name)} should have create access"
      assert_equal policy.new?, policy.create?
    end

    policy = PersonPolicy.new(@bronze_user, Person)
    assert_not policy.create?
    assert_equal policy.new?, policy.create?
  end

  # UPDATE TESTS
  test 'update? delegates to new?' do
    [@silver_user, @gold_user, @admin_user].each do |user|
      policy = PersonPolicy.new(user, @person)
      assert policy.update?, "#{user.roles.pluck(:name)} should have update access"
      assert_equal policy.new?, policy.update?
    end

    policy = PersonPolicy.new(@bronze_user, @person)
    assert_not policy.update?
    assert_equal policy.new?, policy.update?
  end

  # DESTROY TESTS
  test 'destroy? allows gold and admin users only' do
    [@gold_user, @admin_user].each do |user|
      policy = PersonPolicy.new(user, @person)
      assert policy.destroy?, "#{user.roles.pluck(:name)} should have destroy access"
    end
  end

  test 'destroy? denies silver and bronze users' do
    [@silver_user, @bronze_user].each do |user|
      policy = PersonPolicy.new(user, @person)
      assert_not policy.destroy?, "#{user.roles.pluck(:name)} should not have destroy access"
    end
  end

  test 'destroy? denies unauthenticated users' do
    policy = PersonPolicy.new(nil, @person)
    assert_not policy.destroy?
  end

  # SEARCH_CHILD TESTS
  test 'search_child? delegates to new?' do
    [@silver_user, @gold_user, @admin_user].each do |user|
      policy = PersonPolicy.new(user, @person)
      assert policy.search_child?, "#{user.roles.pluck(:name)} should have search_child access"
      assert_equal policy.new?, policy.search_child?
    end

    policy = PersonPolicy.new(@bronze_user, @person)
    assert_not policy.search_child?
    assert_equal policy.new?, policy.search_child?
  end

  # SEARCH_MATE TESTS
  test 'search_mate? delegates to new?' do
    [@silver_user, @gold_user, @admin_user].each do |user|
      policy = PersonPolicy.new(user, @person)
      assert policy.search_mate?, "#{user.roles.pluck(:name)} should have search_mate access"
      assert_equal policy.new?, policy.search_mate?
    end

    policy = PersonPolicy.new(@bronze_user, @person)
    assert_not policy.search_mate?
    assert_equal policy.new?, policy.search_mate?
  end

  # BIRTHDAYS TESTS
  test 'birthdays? allows everyone' do
    policy = PersonPolicy.new(@admin_user, Person)
    assert policy.birthdays?

    policy = PersonPolicy.new(@bronze_user, Person)
    assert policy.birthdays?

    policy = PersonPolicy.new(nil, Person)
    assert policy.birthdays?
  end

  # ROLE HIERARCHY TESTS
  test 'role hierarchy for creation actions' do
    creation_actions = %i[new? edit? create? update? search_child? search_mate?]

    # Admin and Gold should have all creation permissions
    [@admin_user, @gold_user, @silver_user].each do |user|
      policy = PersonPolicy.new(user, @person)
      creation_actions.each do |action|
        assert policy.send(action), "#{user.roles.pluck(:name)} should have #{action} access"
      end
    end

    # Bronze should not have creation permissions
    policy = PersonPolicy.new(@bronze_user, @person)
    creation_actions.each do |action|
      assert_not policy.send(action), "Bronze users should not have #{action} access"
    end
  end

  test 'role hierarchy for destruction actions' do
    # Only gold and admin should have destroy permissions
    [@gold_user, @admin_user].each do |user|
      policy = PersonPolicy.new(user, @person)
      assert policy.destroy?, "#{user.roles.pluck(:name)} should have destroy access"
    end

    # Silver and bronze should not have destroy permissions
    [@silver_user, @bronze_user].each do |user|
      policy = PersonPolicy.new(user, @person)
      assert_not policy.destroy?, "#{user.roles.pluck(:name)} should not have destroy access"
    end
  end

  # INHERITANCE TESTS
  test 'inherits from ApplicationPolicy' do
    assert PersonPolicy < ApplicationPolicy
  end

  test 'overrides ApplicationPolicy defaults correctly' do
    policy = PersonPolicy.new(@admin_user, @person)

    # These should be overridden to allow access
    assert policy.index?
    assert policy.show?
    assert policy.new?
    assert policy.create?
    assert policy.update?
    assert policy.destroy?
    assert policy.birthdays?
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

    policy = PersonPolicy.new(multi_role_user, @person)

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

    policy = PersonPolicy.new(no_role_user, @person)

    # Should not have privileged access
    assert_not policy.new?
    assert_not policy.destroy?
    assert_not policy.download?

    # But should still have public access
    assert policy.index?
    assert policy.show?
    assert policy.birthdays?
  end

  test 'policy methods work with different record types' do
    # Test with class vs instance
    class_policy = PersonPolicy.new(@admin_user, Person)
    instance_policy = PersonPolicy.new(@admin_user, @person)

    # Both should work for all actions
    assert class_policy.index?
    assert instance_policy.show?

    assert class_policy.new?
    assert instance_policy.destroy?
  end

  test 'nil record handling' do
    policy = PersonPolicy.new(@admin_user, nil)

    # Should not crash and should still check user permissions
    assert policy.index?
    assert policy.new?
    assert policy.destroy?
  end

  test 'all policy methods are defined' do
    policy = PersonPolicy.new(@admin_user, @person)
    expected_methods = %i[
      index? download? show? new? edit? create?
      update? destroy? search_child? search_mate? birthdays?
    ]

    expected_methods.each do |method|
      assert_respond_to policy, method, "Policy should respond to #{method}"
    end
  end

  test 'has_any_role usage works correctly' do
    # Test that has_any_role? correctly identifies users with any of the specified roles

    # Silver user should pass silver/gold/admin check
    policy = PersonPolicy.new(@silver_user, @person)
    assert policy.new? # Uses has_any_role? :silver, :gold, :admin

    # Gold user should pass gold/admin check
    policy = PersonPolicy.new(@gold_user, @person)
    assert policy.destroy? # Uses has_any_role? :gold, :admin

    # Bronze user should fail both checks
    policy = PersonPolicy.new(@bronze_user, @person)
    assert_not policy.new? # Should fail silver/gold/admin check
    assert_not policy.destroy? # Should fail gold/admin check
  end
end
