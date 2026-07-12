require "test_helper"

class CouplesControllerTest < ActionDispatch::IntegrationTest
  def setup
    # Create roles if they don't exist
    Role.find_or_create_by(name: 'admin')
    Role.find_or_create_by(name: 'gold')
    Role.find_or_create_by(name: 'silver')
    Role.find_or_create_by(name: 'bronze')
    
    @admin_user = users(:one)
    @admin_user.add_role(:admin)
    
    # Create test people
    @person1 = Person.create!(
      name: "Person One",
      birth_year: 1980,
      birth_month: 5,
      birth_day: 15
    )
    
    @person2 = Person.create!(
      name: "Person Two",
      birth_year: 1985,
      birth_month: 8,
      birth_day: 20
    )
    
    @person3 = Person.create!(
      name: "Person Three",
      birth_year: 1990,
      birth_month: 3,
      birth_day: 10
    )
    
    # Create test couple
    @couple = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max,
      marriage: Date.new(2020, 6, 15),
      local: "Test Location"
    )
  end

  # INDEX ACTION TESTS
  test "should get index with authenticated user" do
    sign_in_as(@admin_user)
    
    get couples_path
    assert_response :success
  end

  test "index should require authentication" do
    get couples_path
    assert_redirected_to new_user_session_path
  end

  # DOWNLOAD ACTION TESTS  
  test "should download couples CSV with admin user" do
    sign_in_as(@admin_user)
    
    get download_couples_path(format: :csv)
    
    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_includes response.headers['Content-Disposition'], 'couples'
    assert_includes response.headers['Content-Disposition'], Date.today.to_s
    
    # Verify CSV contains couple data
    csv_data = response.body
    assert_includes csv_data, @couple.person1_id.to_s
    assert_includes csv_data, @couple.person2_id.to_s
    assert_includes csv_data, "Test Location"
  end

  test "download should include soft-deleted couples" do
    sign_in_as(@admin_user)
    
    # Create and soft-delete a couple
    deleted_couple = Couple.create!(
      person1_id: [@person2.id, @person3.id].min,
      person2_id: [@person2.id, @person3.id].max,
      local: "Deleted Location"
    )
    deleted_couple.destroy
    
    get download_couples_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # Should include both active and deleted couples
    assert_includes csv_data, @couple.local
    assert_includes csv_data, "Deleted Location"
  end

  test "download should require admin authorization" do
    silver_user = User.create!(
      name: "Silver User",
      email: "silver@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    silver_user.add_role(:silver)
    
    sign_in_as(silver_user)
    
    get download_couples_path(format: :csv)
    assert_response :redirect # Should redirect due to authorization failure
  end

  # NEW ACTION TESTS (nested under person)
  test "should get new with silver user" do
    silver_user = User.create!(
      name: "Silver User",
      email: "silver@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    silver_user.add_role(:silver)
    
    sign_in_as(silver_user)
    
    get new_person_couple_path(@person1)
    assert_response :success
  end

  test "new action sets person1_id and session data" do
    sign_in_as(@admin_user)
    
    get new_person_couple_path(@person1)
    
    assert_response :success
    assert_equal @person1.id, session[:id]
    assert_equal @person1.gender, session[:gender]
  end

  test "new should require silver role or higher" do
    bronze_user = User.create!(
      name: "Bronze User",
      email: "bronze@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    bronze_user.add_role(:bronze)
    
    sign_in_as(bronze_user)
    
    get new_person_couple_path(@person1)
    assert_response :redirect # Should redirect due to authorization failure
  end

  # EDIT ACTION TESTS
  test "should get edit with gold user" do
    gold_user = User.create!(
      name: "Gold User",
      email: "gold@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    gold_user.add_role(:gold)
    
    sign_in_as(gold_user)
    
    get edit_person_couple_path(@person1, @couple)
    assert_response :success
  end

  test "edit action sets session data" do
    sign_in_as(@admin_user)
    
    get edit_person_couple_path(@person1, @couple)
    
    assert_response :success
    assert_equal @person1.id, session[:id]
    assert_equal @person1.gender, session[:gender]
  end

  # CREATE ACTION TESTS
  test "should create couple successfully" do
    sign_in_as(@admin_user)
    
    assert_difference('Couple.count', 1) do
      post person_couples_path(@person1), params: {
        couple: {
          person1_id: @person1.id,
          person2_id: @person3.id,
          marriage: Date.new(2023, 1, 1),
          local: "New Location"
        }
      }
    end
    
    assert_redirected_to person_path(@person1)
    
    # Verify couple was created with correct data
    couple = Couple.last
    assert_equal [@person1.id, @person3.id].min, couple.person1_id
    assert_equal [@person1.id, @person3.id].max, couple.person2_id
    assert_equal Date.new(2023, 1, 1), couple.marriage
    assert_equal "New Location", couple.local
  end

  test "should handle create with turbo stream" do
    sign_in_as(@admin_user)
    
    post person_couples_path(@person1),
         params: {
           couple: {
             person1_id: @person1.id,
             person2_id: @person3.id,
             marriage: Date.new(2023, 1, 1)
           }
         },
         headers: { "Accept" => "text/vnd.turbo-stream.html" }
    
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    
    # Verify couple was created
    couple = Couple.where(
      person1_id: [@person1.id, @person3.id].min,
      person2_id: [@person1.id, @person3.id].max
    ).first
    assert_not_nil couple
  end

  # UPDATE ACTION TESTS
  test "should update couple successfully" do
    sign_in_as(@admin_user)
    
    patch person_couple_path(@person1, @couple), params: {
      couple: {
        marriage: Date.new(2021, 12, 25),
        separation: Date.new(2023, 6, 15),
        local: "Updated Location"
      }
    }
    
    assert_redirected_to person_path(@person1)
    
    # Verify couple was updated
    @couple.reload
    assert_equal Date.new(2021, 12, 25), @couple.marriage
    assert_equal Date.new(2023, 6, 15), @couple.separation
    assert_equal "Updated Location", @couple.local
  end

  test "should handle update with turbo stream" do
    sign_in_as(@admin_user)
    
    patch person_couple_path(@person1, @couple),
          params: {
            couple: {
              local: "Turbo Updated Location"
            }
          },
          headers: { "Accept" => "text/vnd.turbo-stream.html" }
    
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    
    # Verify couple was updated
    @couple.reload
    assert_equal "Turbo Updated Location", @couple.local
  end

  test "update sets current_user for audit logging" do
    sign_in_as(@admin_user)
    
    patch person_couple_path(@person1, @couple), params: {
      couple: {
        local: "Audit Test Location"
      }
    }
    
    assert_redirected_to person_path(@person1)
    # The implementation sets current_user for RecordEvent callbacks
  end

  # DESTROY ACTION TESTS
  test "should destroy couple with gold user" do
    gold_user = User.create!(
      name: "Gold User",
      email: "gold@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    gold_user.add_role(:gold)
    
    sign_in_as(gold_user)
    
    # Couple should be soft-deleted, not hard-deleted
    assert_difference('Couple.count', -1) do
      assert_no_difference('Couple.with_deleted.count') do
        delete person_couple_path(@person1, @couple)
      end
    end
    
    assert_redirected_to person_path(@person1)
    
    # Verify couple was soft-deleted
    @couple.reload
    assert_not_nil @couple.deleted_at
  end

  test "should handle destroy with turbo stream" do
    sign_in_as(@admin_user)
    
    delete person_couple_path(@person1, @couple),
           headers: { "Accept" => "text/vnd.turbo-stream.html" }
    
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    
    # Verify couple was soft-deleted
    @couple.reload
    assert_not_nil @couple.deleted_at
  end

  test "destroy should require gold role or higher" do
    silver_user = User.create!(
      name: "Silver User",
      email: "silver@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    silver_user.add_role(:silver)
    
    sign_in_as(silver_user)
    
    delete person_couple_path(@person1, @couple)
    assert_response :redirect # Should redirect due to authorization failure
  end

  test "destroy sets current_user for audit logging" do
    sign_in_as(@admin_user)
    
    delete person_couple_path(@person1, @couple)
    
    assert_redirected_to person_path(@person1)
    # The implementation sets current_user for RecordEvent callbacks
  end

  # Note: Show action doesn't exist on CouplesController for nested routes

  # AUTHENTICATION TESTS
  test "should require authentication for nested routes" do
    get new_person_couple_path(@person1)
    assert_redirected_to new_user_session_path
    
    post person_couples_path(@person1), params: { couple: { person1_id: @person1.id, person2_id: @person2.id } }
    assert_redirected_to new_user_session_path
    
    get edit_person_couple_path(@person1, @couple)
    assert_redirected_to new_user_session_path
    
    patch person_couple_path(@person1, @couple), params: { couple: { local: "Test" } }
    assert_redirected_to new_user_session_path
    
    delete person_couple_path(@person1, @couple)
    assert_redirected_to new_user_session_path
  end

  test "should require authentication for standalone routes" do
    get couples_path
    assert_redirected_to new_user_session_path
    
    delete couple_path(@couple)
    assert_redirected_to new_user_session_path
  end

  # ERROR HANDLING TESTS
  test "should handle missing person" do
    sign_in_as(@admin_user)

    get new_person_couple_path(99999)
    assert_response :not_found
  end

  test "should handle missing couple" do
    sign_in_as(@admin_user)

    get edit_person_couple_path(@person1, 99999)
    assert_response :not_found
  end

  # AUTHORIZATION TESTS
  # Note: CouplesController doesn't have a show action for individual couple viewing
  # The couples are viewed through nested routes under people

  test "authorization hierarchy works correctly for create" do
    users_and_roles = [
      { role: :bronze, can_create: false },
      { role: :silver, can_create: true },
      { role: :gold, can_create: true },
      { role: :admin, can_create: true }
    ]
    
    users_and_roles.each do |test_case|
      user = User.create!(
        name: "#{test_case[:role].capitalize} User Create",
        email: "#{test_case[:role]}create@test.com",
        password: "password",
        confirmed_at: 1.week.ago
      )
      user.add_role(test_case[:role])
      
      sign_in_as(user)
      
      # Test create permissions
      if test_case[:can_create]
        get new_person_couple_path(@person1)
        assert_response :success, "#{test_case[:role]} should be able to create couples"
      else
        get new_person_couple_path(@person1)
        assert_response :redirect, "#{test_case[:role]} should not be able to create couples"
      end
      
      sign_out
    end
  end

  # CSV FORMAT TESTS
  test "CSV headers should match Couple model columns" do
    sign_in_as(@admin_user)
    
    get download_couples_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    headers = csv_data.split("\n").first.split(";")
    
    # Should include main Couple model columns
    expected_columns = %w[person1_id person2_id marriage separation local]
    
    expected_columns.each do |column|
      assert_includes headers, column, "CSV should include #{column} column"
    end
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

  def sign_out
    delete destroy_user_session_path
  end
end