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
      post person_favorites_path(@person1), as: :json
    end
    assert_response :success

    # Visit people index again - should show the favorite
    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 1
    assert_select "tbody a[href=?]", person_path(@person1)

    # Add second person to favorites
    assert_difference('Favorite.count', 1) do
      post person_favorites_path(@person2), as: :json
    end

    # Visit people index - should show both favorites
    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 2

    # Perform search - should show search results instead of favorites
    get people_path, params: { q: { name_cont: @person1.name } }
    assert_response :success
    assert_select 'tbody tr', count: 1
    assert_select "tbody a[href=?]", person_path(@person1)

    # Clear search - should return to showing favorites
    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 2 # Both favorites again

    # Remove a favorite
    favorite = @user.favorites.find_by(person: @person1)
    assert_difference('Favorite.count', -1) do
      delete person_favorite_path(@person1, favorite), as: :json
    end

    # Verify favorite was removed from index
    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 1
    assert_select "tbody a[href=?]", person_path(@person2)
    assert_select "tbody a[href=?]", person_path(@person1), count: 0
  end

  test "favorites functionality on person show page" do
    # Not favorited yet: the show page has the "add to favorites" form (button_to
    # renders a form posting to the create path). Asserting the form action keeps
    # this independent of markup classes and the user's locale.
    get person_path(@person1)
    assert_response :success
    assert_select "form[action=?]", person_favorites_path(@person1)

    assert_difference("Favorite.count", 1) do
      post person_favorites_path(@person1), as: :json
    end

    # Now favorited: the add form is gone, replaced by the remove form.
    favorite = @user.favorites.find_by(person: @person1)
    get person_path(@person1)
    assert_response :success
    assert_select "form[action=?]", person_favorites_path(@person1), count: 0
    assert_select "form[action=?]", person_favorite_path(@person1, favorite)

    assert_difference("Favorite.count", -1) do
      delete person_favorite_path(@person1, favorite), as: :json
    end

    # Back to the add form.
    get person_path(@person1)
    assert_response :success
    assert_select "form[action=?]", person_favorites_path(@person1)
  end

  test "favorites persist across user sessions" do
    # Add favorite
    post person_favorites_path(@person1), as: :json
    assert_response :success

    # Sign out and back in
    delete destroy_user_session_path
    sign_in_as(@user)

    # Verify favorite persists
    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 1
    assert_select "tbody a[href=?]", person_path(@person1)
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

    # Test search functionality — searching shows matching results (not the
    # favorites view). Assert the observable result rather than the controller
    # ivar (assigns was extracted to a gem and isn't available here).
    get people_path, params: { q: { name_cont: @person1.name } }
    assert_response :success
    assert_select "tbody tr", count: 1
    assert_select "tbody", text: /#{Regexp.escape(@person1.name)}/
  end

  test "error handling for invalid favorite operations" do
    # Try to remove non-existent favorite
    delete person_favorite_path(@person1, 999999), as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 'error', json_response['status']

    # Try to create duplicate favorite
    Favorite.create!(user: @user, person: @person1)
    post person_favorites_path(@person1), as: :json
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