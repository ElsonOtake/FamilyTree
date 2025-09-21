require "test_helper"

class FavoritePolicyTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @other_user = users(:two)
    @person = people(:one)
    @person2 = people(:two)
    @favorite = Favorite.new(user: @user, person: @person)
    @other_favorite = Favorite.new(user: @other_user, person: @person2) # Use different person to avoid uniqueness conflict
    
    # Create another user for additional testing
    @third_user = User.create!(
      name: "Third User",
      email: "third@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
  end

  # INITIALIZATION TESTS
  test "policy initializes correctly with user and favorite" do
    policy = FavoritePolicy.new(@user, @favorite)
    assert_equal @user, policy.user
    assert_equal @favorite, policy.favorite
    assert_equal @favorite, policy.record # Should also be accessible via inherited record
  end

  test "policy has correct attribute readers" do
    policy = FavoritePolicy.new(@user, @favorite)
    
    # Should have both user and favorite attribute readers
    assert_respond_to policy, :user
    assert_respond_to policy, :favorite
    assert_respond_to policy, :record # From ApplicationPolicy
  end

  # CREATE TESTS
  test "create? allows authenticated users" do
    policy = FavoritePolicy.new(@user, @favorite)
    assert policy.create?
    
    policy = FavoritePolicy.new(@other_user, @favorite)
    assert policy.create?
    
    policy = FavoritePolicy.new(@third_user, @favorite)
    assert policy.create?
  end

  test "create? denies unauthenticated users" do
    policy = FavoritePolicy.new(nil, @favorite)
    assert_not policy.create?
  end

  test "create? works with any favorite object" do
    another_person = people(:two)
    another_favorite = Favorite.new(user: @third_user, person: another_person)
    
    policy = FavoritePolicy.new(@user, another_favorite)
    assert policy.create? # User can create any favorite when authenticated
  end

  test "create? handles nil favorite" do
    policy = FavoritePolicy.new(@user, nil)
    assert policy.create? # Should still allow creation for authenticated user
  end

  # DESTROY TESTS
  test "destroy? allows user to destroy their own favorite" do
    # Create a unique favorite for this test
    test_person = Person.create!(name: "Test Person Own", birth_year: 1988)
    saved_favorite = Favorite.create!(user: @user, person: test_person)
    policy = FavoritePolicy.new(@user, saved_favorite)
    assert policy.destroy?
  end

  test "destroy? denies user from destroying another user's favorite" do
    # Create a unique favorite for the other user
    test_person_other = Person.create!(name: "Test Person Other", birth_year: 1989)
    saved_other_favorite = Favorite.create!(user: @other_user, person: test_person_other)
    policy = FavoritePolicy.new(@user, saved_other_favorite)
    assert_not policy.destroy?
  end

  test "destroy? denies third party from destroying any favorite" do
    # Create unique favorites for this test
    test_person_third1 = Person.create!(name: "Test Person Third 1", birth_year: 1985)
    test_person_third2 = Person.create!(name: "Test Person Third 2", birth_year: 1986)
    user_favorite = Favorite.create!(user: @user, person: test_person_third1)
    other_user_favorite = Favorite.create!(user: @other_user, person: test_person_third2)
    
    third_user_favorite = Favorite.create!(user: @third_user, person: Person.create!(name: "Third Person", birth_year: 1995))
    
    policy = FavoritePolicy.new(@third_user, user_favorite)
    assert_not policy.destroy?
    
    policy = FavoritePolicy.new(@third_user, other_user_favorite)
    assert_not policy.destroy?
  end

  test "destroy? denies unauthenticated users" do
    # Create a unique favorite for this test
    test_person_unauth = Person.create!(name: "Test Person Unauth", birth_year: 1987)
    saved_favorite = Favorite.create!(user: @user, person: test_person_unauth)
    policy = FavoritePolicy.new(nil, saved_favorite)
    assert_not policy.destroy?
  end

  test "destroy? handles nil favorite gracefully" do
    policy = FavoritePolicy.new(@user, nil)
    assert_not policy.destroy?
  end

  test "destroy? requires both authenticated user and owned favorite" do
    # Create unique favorites for this test
    test_person_req1 = Person.create!(name: "Test Person Req 1", birth_year: 1984)
    test_person_req2 = Person.create!(name: "Test Person Req 2", birth_year: 1983)
    user_favorite = Favorite.create!(user: @user, person: test_person_req1)
    other_favorite = Favorite.create!(user: @other_user, person: test_person_req2)
    
    # Both conditions must be true
    policy = FavoritePolicy.new(@user, user_favorite)
    assert @user.present? # User is present
    assert_equal user_favorite.user, @user # User owns the favorite
    assert policy.destroy?
    
    # If user is nil, should fail
    policy = FavoritePolicy.new(nil, user_favorite)
    assert_not policy.destroy?
    
    # If favorite belongs to someone else, should fail
    policy = FavoritePolicy.new(@user, other_favorite)
    assert_not policy.destroy?
  end

  # DEFAULT BEHAVIOR TESTS (inherited from ApplicationPolicy)
  test "inherits ApplicationPolicy defaults for non-overridden methods" do
    policy = FavoritePolicy.new(@user, @favorite)
    
    # FavoritePolicy only overrides create? and destroy?, all others should use ApplicationPolicy defaults
    assert_not policy.index?
    assert_not policy.show?
    assert_not policy.update?
    assert_not policy.edit?
    
    # Note: new? delegates to create?, so it returns the same as create? (true for authenticated user)
    assert policy.new?
    assert_equal policy.create?, policy.new?
  end

  test "new? delegates to create?" do
    policy = FavoritePolicy.new(@user, @favorite)
    assert_equal policy.create?, policy.new?
    
    policy = FavoritePolicy.new(nil, @favorite)
    assert_equal policy.create?, policy.new?
  end

  test "edit? delegates to update?" do
    policy = FavoritePolicy.new(@user, @favorite)
    assert_equal policy.update?, policy.edit?
  end

  # INHERITANCE TESTS
  test "inherits from ApplicationPolicy" do
    assert FavoritePolicy < ApplicationPolicy
  end

  test "only overrides create? and destroy? methods" do
    # FavoritePolicy should only define create? and destroy?, all others inherited
    favorite_methods = FavoritePolicy.instance_methods(false)
    expected_overrides = [:create?, :destroy?]
    
    expected_overrides.each do |method|
      assert_includes favorite_methods, method, "FavoritePolicy should override #{method}"
    end
    
    # Should not override other methods
    not_overridden = [:index?, :show?, :new?, :update?, :edit?]
    not_overridden.each do |method|
      assert_not_includes favorite_methods, method, "FavoritePolicy should not override #{method}"
    end
  end

  # OWNERSHIP TESTS
  test "ownership logic works correctly" do
    # Create unique favorites for this test
    test_person_own1 = Person.create!(name: "Test Person Own 1", birth_year: 1982)
    test_person_own2 = Person.create!(name: "Test Person Own 2", birth_year: 1981)
    user_favorite = Favorite.create!(user: @user, person: test_person_own1)
    other_user_favorite = Favorite.create!(user: @other_user, person: test_person_own2)
    
    # Test that favorite.user comparison works
    assert_equal user_favorite.user, @user
    assert_not_equal user_favorite.user, @other_user
    assert_equal other_user_favorite.user, @other_user
    assert_not_equal other_user_favorite.user, @user
    
    # Test policies reflect ownership
    policy_own = FavoritePolicy.new(@user, user_favorite)
    policy_other = FavoritePolicy.new(@user, other_user_favorite)
    
    assert policy_own.destroy?
    assert_not policy_other.destroy?
  end

  test "handles different favorite configurations" do
    # Test with different people
    another_person = Person.create!(name: "Another Person", birth_year: 1990)
    user_favorite = Favorite.create!(user: @user, person: another_person)
    # Use a different person to avoid unique constraint issues
    another_person2 = Person.create!(name: "Another Person 2", birth_year: 1991)
    other_user_favorite = Favorite.create!(user: @other_user, person: another_person2)
    
    # User can only destroy their own favorite
    policy_own = FavoritePolicy.new(@user, user_favorite)
    policy_other = FavoritePolicy.new(@user, other_user_favorite)
    
    assert policy_own.destroy?
    assert_not policy_other.destroy?
  end

  # EDGE CASES
  test "handles unsaved favorites" do
    # Use a different person to avoid unique constraint conflicts
    test_person = Person.create!(name: "Test Person for Unsaved", birth_year: 1992)
    unsaved_favorite = Favorite.new(user: @user, person: test_person)
    
    policy = FavoritePolicy.new(@user, unsaved_favorite)
    assert policy.create?
    assert policy.destroy? # User owns this favorite even if unsaved
    
    policy = FavoritePolicy.new(@other_user, unsaved_favorite)
    assert policy.create? # Anyone can create
    assert_not policy.destroy? # But can't destroy if not owner
  end

  test "handles favorites with nil person" do
    favorite_with_nil_person = Favorite.new(user: @user, person: nil)
    
    policy = FavoritePolicy.new(@user, favorite_with_nil_person)
    assert policy.create?
    assert policy.destroy?
  end

  test "handles favorites with nil user" do
    # Use a different person to avoid unique constraint conflicts  
    test_person_nil_user = Person.create!(name: "Test Person Nil User", birth_year: 1993)
    favorite_with_nil_user = Favorite.new(user: nil, person: test_person_nil_user)
    
    # User can create any favorite
    policy = FavoritePolicy.new(@user, favorite_with_nil_user)
    assert policy.create?
    
    # But can't destroy it since they don't own it (favorite.user is nil)
    assert_not policy.destroy?
  end

  test "nil user with nil favorite" do
    policy = FavoritePolicy.new(nil, nil)
    assert_not policy.create?
    assert_not policy.destroy?
  end

  test "all expected policy methods are defined" do
    policy = FavoritePolicy.new(@user, @favorite)
    expected_methods = [
      :index?, :show?, :create?, :new?, :update?, :edit?, :destroy?
    ]
    
    expected_methods.each do |method|
      assert_respond_to policy, method, "Policy should respond to #{method}"
    end
  end

  test "policy maintains consistent behavior across instances" do
    # Create multiple favorites for same user - use all new people to avoid conflicts
    person1 = Person.create!(name: "Person 1 Consistent", birth_year: 1984)
    person2 = Person.create!(name: "Person 2 Consistent", birth_year: 1985)
    person3 = Person.create!(name: "Person 3 Consistent", birth_year: 1990)
    
    favorite1 = Favorite.create!(user: @user, person: person1)
    favorite2 = Favorite.create!(user: @user, person: person2)
    favorite3 = Favorite.create!(user: @user, person: person3)
    
    # All should have same permissions for owner
    [favorite1, favorite2, favorite3].each do |fav|
      policy = FavoritePolicy.new(@user, fav)
      assert policy.create?, "Should be able to create favorite for #{fav.person&.name}"
      assert policy.destroy?, "Should be able to destroy own favorite for #{fav.person&.name}"
    end
    
    # All should have same permissions for non-owner
    [favorite1, favorite2, favorite3].each do |fav|
      policy = FavoritePolicy.new(@other_user, fav)
      assert policy.create?, "Should be able to create any favorite"
      assert_not policy.destroy?, "Should not be able to destroy others' favorite for #{fav.person&.name}"
    end
  end

  test "comparison with other policies shows distinct behavior" do
    # FavoritePolicy has unique ownership-based authorization
    # Unlike other policies that are role-based
    
    # No roles needed for FavoritePolicy
    user_without_roles = User.create!(
      name: "No Roles User",
      email: "noroles@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    
    unique_person = Person.create!(name: "Unique Person", birth_year: 1985)
    user_favorite = Favorite.create!(user: user_without_roles, person: unique_person)
    policy = FavoritePolicy.new(user_without_roles, user_favorite)
    
    # Should work based on ownership, not roles
    assert policy.create?
    assert policy.destroy?
    
    # Compare with PersonPolicy which requires roles
    person_policy = PersonPolicy.new(user_without_roles, @person)
    assert_not person_policy.create? # Requires silver+ role
    assert_not person_policy.destroy? # Requires gold+ role
  end
end