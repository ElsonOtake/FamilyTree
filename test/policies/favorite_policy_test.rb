require "test_helper"

class FavoritePolicyTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @other_user = users(:two)
    @person = people(:one)
    @favorite = Favorite.new(user: @user, person: @person)
    @other_favorite = Favorite.new(user: @other_user, person: @person)
  end

  test "create? allows authenticated users" do
    policy = FavoritePolicy.new(@user, @favorite)
    assert policy.create?
  end

  test "create? denies unauthenticated users" do
    policy = FavoritePolicy.new(nil, @favorite)
    assert_not policy.create?
  end

  test "destroy? allows user to destroy their own favorite" do
    @favorite.save!
    policy = FavoritePolicy.new(@user, @favorite)
    assert policy.destroy?
  end

  test "destroy? denies user from destroying another user's favorite" do
    @other_favorite.save!
    policy = FavoritePolicy.new(@user, @other_favorite)
    assert_not policy.destroy?
  end

  test "destroy? denies unauthenticated users" do
    @favorite.save!
    policy = FavoritePolicy.new(nil, @favorite)
    assert_not policy.destroy?
  end

  test "destroy? handles nil favorite gracefully" do
    policy = FavoritePolicy.new(@user, nil)
    assert_not policy.destroy?
  end

  test "policy initializes correctly with user and favorite" do
    policy = FavoritePolicy.new(@user, @favorite)
    assert_equal @user, policy.user
    assert_equal @favorite, policy.favorite
  end
end