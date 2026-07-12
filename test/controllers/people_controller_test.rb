require "test_helper"

class PeopleControllerTest < ActionDispatch::IntegrationTest
  setup do
    @person = people(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get people_url
    assert_response :success
  end

  test "should get new" do
    get new_person_url
    assert_response :success
  end

  test "should create person" do
    assert_difference("Person.count") do
      post people_url, params: { person: { alive: @person.alive, birth: @person.birth, death: @person.death, name: @person.name, description: @person.description, gender: @person.gender } }
    end

    assert_redirected_to person_url(Person.last)
  end

  test "creates a new person as a child of a couple" do
    @user.add_role(:admin)
    dad = Person.create!(name: "Create Dad", gender: "M")
    mom = Person.create!(name: "Create Mom", gender: "F")
    couple = Couple.create!(person1: dad, person2: mom)

    assert_difference ["Person.count", "Child.count"], 1 do
      post people_url, params: { person: { name: "New Kid", gender: "M", couple: couple.id } }
    end

    assert_redirected_to person_url(dad)
    assert_includes couple.reload.people.map(&:name), "New Kid"
  end

  test "should show person" do
    get person_url(@person)
    assert_response :success
  end

  test "should get edit" do
    get edit_person_url(@person)
    assert_response :success
  end

  test "should update person" do
    patch person_url(@person), params: { person: { alive: @person.alive, birth: @person.birth, death: @person.death, name: @person.name, description: @person.description, gender: @person.gender } }
    assert_redirected_to person_url(@person)
  end

  test "should destroy person" do
    assert_difference("Person.count", -1) do
      delete person_url(@person)
    end

    assert_redirected_to people_url
  end

  test "birthdays action shows favorites when available" do
    # Create people with birthdays
    person_with_birthday = Person.create!(
      name: "Birthday Person",
      birth_year: 1990,
      birth_month: 9,
      birth_day: 20
    )
    
    person_without_favorites = Person.create!(
      name: "Non-favorite Person", 
      birth_year: 1985,
      birth_month: 9,
      birth_day: 21
    )

    # Add one person to favorites
    @user.favorites.create!(person: person_with_birthday)

    travel_to Date.new(2025, 9, 20) do
      get birthdays_people_url
      assert_response :success
      
      # Should show the birthday page
      assert_select 'h1', text: /#{I18n.t('people.birthdays.title')}/
      
      # Should show the favorited person's name in the birthday listing
      assert_select 'body', text: /Birthday Person/
    end
  end

  test "birthdays action falls back to all people when no favorites" do
    # Clear any existing favorites for this user  
    @user.favorites.destroy_all
    
    # Create people with birthdays but no favorites
    person_with_birthday = Person.create!(
      name: "Birthday Person",
      birth_year: 1990,
      birth_month: 9,
      birth_day: 20
    )

    travel_to Date.new(2025, 9, 20) do
      get birthdays_people_url
      assert_response :success
      
      # Should show the birthday page with all people
      assert_select 'h1', text: /#{I18n.t('people.birthdays.title')}/
      assert_select 'body', text: /Birthday Person/
    end
  end

  private

  def sign_in(user)
    post user_session_path, params: { user: { email: user.email, password: 'password' } }
  end
end
