# frozen_string_literal: true

require 'test_helper'

class CouplePolicyTest < ActiveSupport::TestCase
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

    @couple = couples(:one)
  end

  # INITIALIZATION TESTS
  test 'policy initializes correctly with user and couple' do
    policy = CouplePolicy.new(@admin_user, @couple)
    assert_equal @admin_user, policy.user
    assert_equal @couple, policy.record
  end

  test 'policy custom attribute readers work' do
    policy = CouplePolicy.new(@admin_user, @couple)
    assert_equal @admin_user, policy.user
    # The policy assigns @couple but doesn't have attr_reader for it
    # The record is still accessible via inherited record attr_reader
    assert_equal @couple, policy.record
  end

  # INDEX TESTS
  test 'index? allows everyone' do
    policy = CouplePolicy.new(@admin_user, Couple)
    assert policy.index?

    policy = CouplePolicy.new(@bronze_user, Couple)
    assert policy.index?

    policy = CouplePolicy.new(nil, Couple)
    assert policy.index?
  end

  # DOWNLOAD TESTS
  test 'download? allows admin users only' do
    policy = CouplePolicy.new(@admin_user, Couple)
    assert policy.download?
  end

  test 'download? denies non-admin users' do
    [@gold_user, @silver_user, @bronze_user].each do |user|
      policy = CouplePolicy.new(user, Couple)
      assert_not policy.download?, "#{user.roles.pluck(:name)} should not have download access"
    end
  end

  test 'download? denies unauthenticated users' do
    policy = CouplePolicy.new(nil, Couple)
    assert_not policy.download?
  end

  # SHOW TESTS
  test 'show? allows everyone' do
    policy = CouplePolicy.new(@admin_user, @couple)
    assert policy.show?

    policy = CouplePolicy.new(@bronze_user, @couple)
    assert policy.show?

    policy = CouplePolicy.new(nil, @couple)
    assert policy.show?
  end

  # NEW TESTS
  test 'new? allows silver, gold, and admin users' do
    [@silver_user, @gold_user, @admin_user].each do |user|
      policy = CouplePolicy.new(user, Couple)
      assert policy.new?, "#{user.roles.pluck(:name)} should have new access"
    end
  end

  test 'new? denies bronze users' do
    policy = CouplePolicy.new(@bronze_user, Couple)
    assert_not policy.new?
  end

  test 'new? denies unauthenticated users' do
    policy = CouplePolicy.new(nil, Couple)
    assert_not policy.new?
  end

  # EDIT TESTS
  test 'edit? delegates to new?' do
    [@silver_user, @gold_user, @admin_user].each do |user|
      policy = CouplePolicy.new(user, @couple)
      assert policy.edit?, "#{user.roles.pluck(:name)} should have edit access"
      assert_equal policy.new?, policy.edit?
    end

    policy = CouplePolicy.new(@bronze_user, @couple)
    assert_not policy.edit?
    assert_equal policy.new?, policy.edit?
  end

  # CREATE TESTS
  test 'create? delegates to new?' do
    [@silver_user, @gold_user, @admin_user].each do |user|
      policy = CouplePolicy.new(user, Couple)
      assert policy.create?, "#{user.roles.pluck(:name)} should have create access"
      assert_equal policy.new?, policy.create?
    end

    policy = CouplePolicy.new(@bronze_user, Couple)
    assert_not policy.create?
    assert_equal policy.new?, policy.create?
  end

  # UPDATE TESTS
  test 'update? delegates to new?' do
    [@silver_user, @gold_user, @admin_user].each do |user|
      policy = CouplePolicy.new(user, @couple)
      assert policy.update?, "#{user.roles.pluck(:name)} should have update access"
      assert_equal policy.new?, policy.update?
    end

    policy = CouplePolicy.new(@bronze_user, @couple)
    assert_not policy.update?
    assert_equal policy.new?, policy.update?
  end

  # DESTROY TESTS
  test 'destroy? allows gold and admin users only' do
    [@gold_user, @admin_user].each do |user|
      policy = CouplePolicy.new(user, @couple)
      assert policy.destroy?, "#{user.roles.pluck(:name)} should have destroy access"
    end
  end

  test 'destroy? denies silver and bronze users' do
    [@silver_user, @bronze_user].each do |user|
      policy = CouplePolicy.new(user, @couple)
      assert_not policy.destroy?, "#{user.roles.pluck(:name)} should not have destroy access"
    end
  end

  test 'destroy? denies unauthenticated users' do
    policy = CouplePolicy.new(nil, @couple)
    assert_not policy.destroy?
  end

  # ROLE HIERARCHY TESTS
  test 'role hierarchy for creation actions' do
    creation_actions = %i[new? edit? create? update?]

    # Admin, Gold, and Silver should have all creation permissions
    [@admin_user, @gold_user, @silver_user].each do |user|
      policy = CouplePolicy.new(user, @couple)
      creation_actions.each do |action|
        assert policy.send(action), "#{user.roles.pluck(:name)} should have #{action} access"
      end
    end

    # Bronze should not have creation permissions
    policy = CouplePolicy.new(@bronze_user, @couple)
    creation_actions.each do |action|
      assert_not policy.send(action), "Bronze users should not have #{action} access"
    end
  end

  test 'role hierarchy for destruction actions' do
    # Only gold and admin should have destroy permissions
    [@gold_user, @admin_user].each do |user|
      policy = CouplePolicy.new(user, @couple)
      assert policy.destroy?, "#{user.roles.pluck(:name)} should have destroy access"
    end

    # Silver and bronze should not have destroy permissions
    [@silver_user, @bronze_user].each do |user|
      policy = CouplePolicy.new(user, @couple)
      assert_not policy.destroy?, "#{user.roles.pluck(:name)} should not have destroy access"
    end
  end

  # INHERITANCE TESTS
  test 'inherits from ApplicationPolicy' do
    assert CouplePolicy < ApplicationPolicy
  end

  test 'overrides ApplicationPolicy defaults correctly' do
    policy = CouplePolicy.new(@admin_user, @couple)

    # These should be overridden to allow access
    assert policy.index?
    assert policy.show?
    assert policy.new?
    assert policy.create?
    assert policy.update?
    assert policy.destroy?
  end

  test 'policy follows same pattern as PersonPolicy' do
    # CouplePolicy and PersonPolicy should have identical authorization rules
    person_policy = PersonPolicy.new(@admin_user, people(:one))
    couple_policy = CouplePolicy.new(@admin_user, @couple)

    # Public access methods
    assert_equal person_policy.index?, couple_policy.index?
    assert_equal person_policy.show?, couple_policy.show?

    # Creation methods (require silver+)
    assert_equal person_policy.new?, couple_policy.new?
    assert_equal person_policy.create?, couple_policy.create?
    assert_equal person_policy.update?, couple_policy.update?

    # Destruction methods (require gold+)
    assert_equal person_policy.destroy?, couple_policy.destroy?

    # Admin-only methods
    assert_equal person_policy.download?, couple_policy.download?
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

    policy = CouplePolicy.new(multi_role_user, @couple)

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

    policy = CouplePolicy.new(no_role_user, @couple)

    # Should not have privileged access
    assert_not policy.new?
    assert_not policy.destroy?
    assert_not policy.download?

    # But should still have public access
    assert policy.index?
    assert policy.show?
  end

  test 'policy methods work with different record types' do
    # Test with class vs instance
    class_policy = CouplePolicy.new(@admin_user, Couple)
    instance_policy = CouplePolicy.new(@admin_user, @couple)

    # Both should work for all actions
    assert class_policy.index?
    assert instance_policy.show?

    assert class_policy.new?
    assert instance_policy.destroy?
  end

  test 'nil record handling' do
    policy = CouplePolicy.new(@admin_user, nil)

    # Should not crash and should still check user permissions
    assert policy.index?
    assert policy.new?
    assert policy.destroy?
  end

  test 'all policy methods are defined' do
    policy = CouplePolicy.new(@admin_user, @couple)
    expected_methods = %i[
      index? download? show? new? edit? create?
      update? destroy?
    ]

    expected_methods.each do |method|
      assert_respond_to policy, method, "Policy should respond to #{method}"
    end
  end

  test 'has_any_role usage works correctly' do
    # Test that has_any_role? correctly identifies users with any of the specified roles

    # Silver user should pass silver/gold/admin check
    policy = CouplePolicy.new(@silver_user, @couple)
    assert policy.new? # Uses has_any_role? :silver, :gold, :admin

    # Gold user should pass gold/admin check
    policy = CouplePolicy.new(@gold_user, @couple)
    assert policy.destroy? # Uses has_any_role? :gold, :admin

    # Bronze user should fail both checks
    policy = CouplePolicy.new(@bronze_user, @couple)
    assert_not policy.new? # Should fail silver/gold/admin check
    assert_not policy.destroy? # Should fail gold/admin check
  end

  test 'policy is consistent across different couple instances' do
    # Create another couple to test consistency
    person1 = Person.create!(name: 'Test Person 1', birth_year: 1980)
    person2 = Person.create!(name: 'Test Person 2', birth_year: 1981)
    another_couple = Couple.create!(person1: person1, person2: person2)

    original_policy = CouplePolicy.new(@silver_user, @couple)
    another_policy = CouplePolicy.new(@silver_user, another_couple)

    # Permissions should be the same regardless of which couple instance
    assert_equal original_policy.show?, another_policy.show?
    assert_equal original_policy.new?, another_policy.new?
    assert_equal original_policy.destroy?, another_policy.destroy?
  end
end
