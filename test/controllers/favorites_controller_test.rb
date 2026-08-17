require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @person = people(:one)
    @other_user = users(:two)
    sign_in @user
  end

  # CREATE tests
  test "should create favorite when authenticated" do
    assert_difference('Favorite.count', 1) do
      post person_favorites_path(@person), as: :json
    end
    
    assert_response :success
    favorite = Favorite.find_by(user: @user, person: @person)
    assert favorite
  end

  test "should return JSON response when creating favorite" do
    post person_favorites_path(@person), as: :json, headers: { 'Accept' => 'application/json' }
    
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 'favorited', json_response['status']
    assert json_response['id']
    assert json_response['message']
  end

  test "should redirect with HTML response when creating favorite" do
    post person_favorites_path(@person)
    
    assert_redirected_to @person
    follow_redirect!
    assert_match I18n.t('favorites.added'), response.body
  end

  test "should not create duplicate favorite" do
    Favorite.create!(user: @user, person: @person)
    
    assert_no_difference('Favorite.count') do
      post person_favorites_path(@person), as: :json
    end
    
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 'error', json_response['status']
  end

  test "should require authentication for create" do
    sign_out @user
    
    assert_no_difference('Favorite.count') do
      post person_favorites_path(@person)
    end
    
    assert_redirected_to new_user_session_path
  end

  # DESTROY tests
  test "should destroy favorite when user owns it" do
    favorite = Favorite.create!(user: @user, person: @person)
    
    assert_difference('Favorite.count', -1) do
      delete person_favorite_path(@person, favorite), as: :json
    end
    
    assert_response :success
  end

  test "should return JSON response when destroying favorite" do
    favorite = Favorite.create!(user: @user, person: @person)
    
    delete person_favorite_path(@person, favorite), as: :json, headers: { 'Accept' => 'application/json' }
    
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 'unfavorited', json_response['status']
    assert json_response['message']
  end

  test "should redirect with HTML response when destroying favorite" do
    favorite = Favorite.create!(user: @user, person: @person)
    
    delete person_favorite_path(@person, favorite)
    
    assert_redirected_to @person
    follow_redirect!
    assert_match I18n.t('favorites.removed'), response.body
  end

  test "should not destroy favorite that doesn't exist" do
    delete person_favorite_path(@person, 999999), as: :json
    
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 'error', json_response['status']
    assert_equal I18n.t('favorites.not_found'), json_response['message']
  end

  test "should require authentication for destroy" do
    favorite = Favorite.create!(user: @user, person: @person)
    sign_out @user
    
    assert_no_difference('Favorite.count') do
      delete person_favorite_path(@person, favorite)
    end
    
    assert_redirected_to new_user_session_path
  end

  test "should not allow user to destroy another user's favorite" do
    other_favorite = Favorite.create!(user: @other_user, person: @person)
    
    assert_no_difference('Favorite.count') do
      delete person_favorite_path(@person, other_favorite)
    end
    
    assert_response :redirect # Pundit redirects unauthorized actions
  end

  test "should handle person not found" do
    # Rails rescues RecordNotFound into a 404 response rather than re-raising.
    post "/individuos/999999/favorites"
    assert_response :not_found
  end

  # AUDIT EVENT tests
  # Use a freshly-created person: the fixtures already have user one favoriting
  # person one, so re-favoriting @person would be a no-op (no event).
  test "favoriting records a favorite.create event scoped to the person" do
    target = Person.create!(name: "Fav Target", gender: "X")

    assert_difference -> { @user.events.where(name: 'favorite.create').count }, 1 do
      post person_favorites_path(target), xhr: true
    end

    event = @user.events.where(name: 'favorite.create').order(:id).last
    assert_equal target, event.resource
    assert_equal target.id, event.data['person_id']
  end

  test "unfavoriting records a favorite.unlink event scoped to the person" do
    target = Person.create!(name: "Unfav Target", gender: "X")
    favorite = Favorite.create!(user: @user, person: target)

    assert_difference -> { @user.events.where(name: 'favorite.unlink').count }, 1 do
      delete person_favorite_path(target, favorite), xhr: true
    end

    event = @user.events.where(name: 'favorite.unlink').order(:id).last
    assert_equal target, event.resource
    assert_equal target.id, event.data['person_id']
  end

  private

  def sign_in(user)
    post user_session_path, params: { user: { email: user.email, password: 'password' } }
  end

  def sign_out(user)
    delete destroy_user_session_path
  end
end
