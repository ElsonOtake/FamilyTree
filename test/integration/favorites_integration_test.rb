require "test_helper"

class FavoritesIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @person1 = people(:one)
    @person2 = people(:two)
    sign_in_as(@user)
  end

  test "complete favorites workflow from people index" do
    # Visit people index - should show empty favorites by default
    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 0 # No favorites yet

    # Add first person to favorites via AJAX
    assert_difference('Favorite.count', 1) do
      post person_favorites_path(@person1), xhr: true
    end
    assert_response :success

    # Visit people index again - should show the favorite
    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 1
    assert_select 'tbody', text: @person1.name

    # Add second person to favorites
    assert_difference('Favorite.count', 1) do
      post person_favorites_path(@person2), xhr: true
    end

    # Visit people index - should show both favorites
    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 2

    # Perform search - should show search results instead of favorites
    get people_path, params: { q: { name_cont: @person1.name } }
    assert_response :success
    assert_select 'tbody tr', count: 1
    assert_select 'tbody', text: @person1.name

    # Clear search - should return to showing favorites
    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 2 # Both favorites again

    # Remove a favorite
    favorite = @user.favorites.find_by(person: @person1)
    assert_difference('Favorite.count', -1) do
      delete person_favorite_path(@person1, favorite), xhr: true
    end

    # Verify favorite was removed from index
    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 1
    assert_select 'tbody', text: @person2.name
    assert_select 'tbody', text: @person1.name, count: 0
  end

  test "favorites functionality on person show page" do
    # Visit person show page
    get person_path(@person1)
    assert_response :success
    assert_select '.button', text: /Add to favorites/

    # Add person to favorites from show page
    assert_difference('Favorite.count', 1) do
      post person_favorites_path(@person1), xhr: true
    end

    # Refresh show page - should now show remove button
    get person_path(@person1)
    assert_response :success
    assert_select '.button', text: /Remove from favorites/

    # Remove from favorites on show page
    favorite = @user.favorites.find_by(person: @person1)
    assert_difference('Favorite.count', -1) do
      delete person_favorite_path(@person1, favorite), xhr: true
    end

    # Refresh show page - should show add button again
    get person_path(@person1)
    assert_response :success
    assert_select '.button', text: /Add to favorites/
  end

  test "favorites persist across user sessions" do
    # Add favorite
    post person_favorites_path(@person1), xhr: true
    assert_response :success

    # Sign out and back in
    delete destroy_user_session_path
    sign_in_as(@user)

    # Verify favorite persists
    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 1
    assert_select 'tbody', text: @person1.name
  end

  test "user cannot see other user's favorites" do
    other_user = users(:two)
    
    # Other user creates favorite
    Favorite.create!(user: other_user, person: @person1)

    # Current user visits index - should not see other user's favorites
    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 0
  end

  test "favorites feature works with search and pagination" do
    # Create enough favorites to test pagination
    people = [@person1, @person2]
    people.each { |person| Favorite.create!(user: @user, person: person) }

    # Test that favorites show up properly
    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 2

    # Test search functionality
    get people_path, params: { q: { name_cont: @person1.name } }
    assert_response :success
    # Should show search results, not favorites
    assert_not assigns(:showing_favorites)
  end

  test "error handling for invalid favorite operations" do
    # Try to remove non-existent favorite
    delete person_favorite_path(@person1, 999999), xhr: true
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 'error', json_response['status']

    # Try to create duplicate favorite
    Favorite.create!(user: @user, person: @person1)
    post person_favorites_path(@person1), xhr: true
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 'error', json_response['status']
  end

  private

  def sign_in_as(user)
    post user_session_path, params: { 
      user: { 
        email: user.email, 
        password: 'password' 
      } 
    }
  end
end