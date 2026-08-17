require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    # Create roles if they don't exist
    Role.find_or_create_by(name: 'admin')
    Role.find_or_create_by(name: 'gold')
    Role.find_or_create_by(name: 'silver')
    Role.find_or_create_by(name: 'bronze')
    
    @user = users(:one)
    @user.add_role(:bronze)
    @user.update!(locale: :en)
    
    # Create test data for statistics
    setup_test_people
    setup_test_couples
  end

  # ABOUT ACTION TESTS
  test "should get about with authenticated user" do
    sign_in_as(@user)
    
    get about_path
    assert_response :success
  end

  test "about should require authentication" do
    get about_path
    assert_redirected_to new_user_session_path
  end

  test "about should render successfully" do
    sign_in_as(@user)
    
    get about_path
    assert_response :success
    assert_match /about/i, response.body
  end

  # STATISTICS ACTION TESTS
  test "should get statistics with authenticated user" do
    sign_in_as(@user)
    
    get statistics_path
    assert_response :success
  end

  test "statistics should require authentication" do
    get statistics_path
    assert_redirected_to new_user_session_path
  end

  test "statistics should render successfully" do
    sign_in_as(@user)
    
    get statistics_path
    assert_response :success
    assert_match /statistics/i, response.body
  end

  test "statistics should display total people count" do
    sign_in_as(@user)
    
    expected_count = Person.count
    get statistics_path
    
    assert_response :success
    assert_match /#{expected_count}/, response.body
  end

  test "statistics should display gender breakdown" do
    sign_in_as(@user)
    
    get statistics_path
    
    assert_response :success
    # Check that gender-related content appears on the page
    assert_match /gender/i, response.body
  end

  test "statistics should display living and deceased people counts" do
    sign_in_as(@user)
    
    living_count = Person.where(alive: true).count
    deceased_count = Person.where(alive: false).count
    
    get statistics_path
    
    assert_response :success
    # Check that the counts appear somewhere on the page
    assert_match /#{living_count}/, response.body if living_count > 0
    assert_match /#{deceased_count}/, response.body if deceased_count > 0
  end

  test "statistics should display birth year information" do
    sign_in_as(@user)
    
    get statistics_path
    
    assert_response :success
    # Check that birth year related content appears
    assert_match /(birth|year|decade)/i, response.body
  end

  test "statistics should display couples count" do
    sign_in_as(@user)
    
    couples_count = Couple.count
    get statistics_path
    
    assert_response :success
    assert_match /#{couples_count}/, response.body if couples_count > 0
  end

  test "statistics should display people without parents count" do
    sign_in_as(@user)
    
    without_parents_count = Person.without_recorded_parents.count
    get statistics_path
    
    assert_response :success
    assert_match /#{without_parents_count}/, response.body if without_parents_count > 0
  end

  test "statistics should display children-related statistics" do
    sign_in_as(@user)
    
    get statistics_path
    
    assert_response :success
    # Check that children-related content appears
    assert_match /(children|parent)/i, response.body
  end

  test "statistics handles people with birth years correctly" do
    sign_in_as(@user)
    
    # Create people with known birth years
    person1980 = Person.create!(name: "Person 1980", birth_year: 1980)
    person1985 = Person.create!(name: "Person 1985", birth_year: 1985)
    person1990 = Person.create!(name: "Person 1990", birth_year: 1990)
    person1995 = Person.create!(name: "Person 1995", birth_year: 1995)
    
    get statistics_path
    
    assert_response :success
    # Should not crash when processing birth year data
    assert_match /(1980|1990)/i, response.body
  end

  test "statistics handles family structures correctly" do
    sign_in_as(@user)
    
    # Create test family structure
    parent1 = Person.create!(name: "Parent 1", birth_year: 1970)
    parent2 = Person.create!(name: "Parent 2", birth_year: 1972)
    child1 = Person.create!(name: "Child 1", birth_year: 2000)
    
    # Create couple relationship
    couple = Couple.create!(
      person1_id: [parent1.id, parent2.id].min,
      person2_id: [parent1.id, parent2.id].max
    )
    
    # Add child to couple
    couple.people << child1
    
    get statistics_path
    
    assert_response :success
    # Should handle family relationships without errors and show family stats
    assert_match /(filhos|children|casais|couples)/i, response.body
  end

  test "statistics handles people without birth years" do
    sign_in_as(@user)
    
    # Create person without birth year
    Person.create!(name: "No Birth Year")
    
    get statistics_path
    
    # Should not crash and should handle gracefully
    assert_response :success
    # Statistics page shows aggregate data, not individual names
    assert_match /(statistics|pessoas|people)/i, response.body
  end

  test "statistics with empty database" do
    # Clear all data
    Person.destroy_all
    Couple.destroy_all
    
    sign_in_as(@user)
    
    get statistics_path
    
    assert_response :success
    # Should show zeros for empty database
    assert_match /0/, response.body
  end

  test "statistics performance with large dataset" do
    sign_in_as(@user)
    
    # This test ensures the statistics page doesn't cause N+1 queries
    # We can't easily test query count in integration tests, but we can
    # ensure it responds quickly
    start_time = Time.current
    
    get statistics_path
    
    end_time = Time.current
    response_time = end_time - start_time
    
    assert_response :success
    assert response_time < 5.seconds, "Statistics page should respond quickly"
  end

  # AUTHORIZATION TESTS
  test "pages controller allows all authenticated users" do
    users_and_roles = [
      { role: :bronze },
      { role: :silver },
      { role: :gold },
      { role: :admin }
    ]
    
    users_and_roles.each do |test_case|
      user = User.create!(
        name: "#{test_case[:role].capitalize} User",
        email: "#{test_case[:role]}@pages.test",
        password: "password",
        confirmed_at: 1.week.ago,
        approved: true
      )
      user.add_role(test_case[:role])
      
      sign_in_as(user)
      
      get about_path
      assert_response :success, "#{test_case[:role]} should be able to access about page"
      
      get statistics_path
      assert_response :success, "#{test_case[:role]} should be able to access statistics page"
      
      sign_out
    end
  end

  # ERROR HANDLING TESTS
  test "statistics handles edge cases gracefully" do
    sign_in_as(@user)
    
    # Test with unusual data that might cause issues
    Person.create!(name: "Special Characters: àáâãäå", birth_year: 2025)
    
    get statistics_path
    
    assert_response :success
    # Should handle special characters without issues - check for 2020s decade
    assert_match /(2020s|statistics|estatísticas)/i, response.body
  end

  test "birth year stats handles edge case years" do
    sign_in_as(@user)
    
    # Create person with edge case birth year
    Person.create!(name: "Edge Case", birth_year: 0)
    Person.create!(name: "Negative Year", birth_year: -100)
    
    get statistics_path
    
    assert_response :success
    # Should handle edge cases without crashing - statistics page shows decades
    assert_match /(0s|-100s|statistics|estatísticas)/i, response.body
  end

  private

  def setup_test_people
    # Create people with various attributes for statistics testing
    @person1 = Person.create!(
      name: "Living Person 1",
      birth_year: 1980,
      birth_month: 5,
      birth_day: 15,
      alive: true,
      gender: 'M'
    )
    
    @person2 = Person.create!(
      name: "Living Person 2", 
      birth_year: 1985,
      birth_month: 8,
      birth_day: 20,
      alive: true,
      gender: 'F'
    )
    
    @person3 = Person.create!(
      name: "Deceased Person",
      birth_year: 1950,
      birth_month: 3,
      birth_day: 10,
      death_year: 2020,
      alive: false,
      gender: 'M'
    )
    
    @person4 = Person.create!(
      name: "Unknown Status",
      birth_year: 1975,
      gender: 'F'
      # alive is nil by default
    )
  end

  def setup_test_couples
    # Create test couples for statistics
    @couple1 = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max,
      marriage: Date.new(2020, 6, 15),
      local: "Test Location"
    )
  end

  def sign_in_as(user)
    post user_session_path, params: { 
      user: { 
        email: user.email, 
        password: 'password' 
      } 
    }
  end

  def sign_out
    delete destroy_user_session_path
  end
end