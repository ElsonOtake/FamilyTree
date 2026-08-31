require "test_helper"

class FavoritesIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @person1 = people(:one)
    @person2 = people(:two)
    sign_in_as(@user)
  end

  test 'complete favorites workflow from people index' do
    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 0

    assert_difference('Favorite.count', 1) do
      post person_favorites_path(@person1), as: :json
    end
    assert_response :success

    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 1
    assert_select 'tbody', text: /#{Regexp.escape(@person1.name)}/

    assert_difference('Favorite.count', 1) do
      post person_favorites_path(@person2), as: :json
    end

    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 2

    get people_path, params: { q: { name_cont: @person1.name } }
    assert_response :success
    assert_select 'tbody tr', count: 1
    assert_select 'tbody', text: /#{Regexp.escape(@person1.name)}/

    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 2

    favorite = @user.favorites.find_by(person: @person1)
    assert_difference('Favorite.count', -1) do
      delete person_favorite_path(@person1, favorite), as: :json
    end

    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 1
    assert_select 'tbody', text: /#{Regexp.escape(@person2.name)}/
    assert_select 'tbody', text: /#{Regexp.escape(@person1.name)}/, count: 0
  end

  test 'favorites functionality on person show page' do
    get person_path(@person1)
    assert_response :success
    assert_select '.btn', text: /#{Regexp.escape(I18n.t('favorites.add'))}/

    assert_difference('Favorite.count', 1) do
      post person_favorites_path(@person1), as: :json
    end

    get person_path(@person1)
    assert_response :success
    assert_select '.btn', text: /#{Regexp.escape(I18n.t('favorites.remove'))}/

    favorite = @user.favorites.find_by(person: @person1)
    assert_difference('Favorite.count', -1) do
      delete person_favorite_path(@person1, favorite), as: :json
    end

    get person_path(@person1)
    assert_response :success
    assert_select '.btn', text: /#{Regexp.escape(I18n.t('favorites.add'))}/
  end

  test 'favorites persist across user sessions' do
    post person_favorites_path(@person1), as: :json
    assert_response :success

    delete destroy_user_session_path
    sign_in_as(@user)

    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 1
    assert_select 'tbody', text: /#{Regexp.escape(@person1.name)}/
  end

  test "user cannot see other user's favorites" do
    other_user = users(:two)
    Favorite.create!(user: other_user, person: @person1)

    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 0
  end

  test 'favorites feature works with search and pagination' do
    people = [@person1, @person2]
    people.each { |person| Favorite.create!(user: @user, person: person) }

    get people_path
    assert_response :success
    assert_select 'tbody tr', count: 2

    get people_path, params: { q: { name_cont: @person1.name } }
    assert_response :success
    # Search results shown, not favorites — one matching row, not the full
    # favorites set of two.
    assert_select 'tbody tr', count: 1
    assert_select 'tbody', text: /#{Regexp.escape(@person1.name)}/
  end

  test 'error handling for invalid favorite operations' do
    delete person_favorite_path(@person1, 999_999), as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 'error', json_response['status']

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
