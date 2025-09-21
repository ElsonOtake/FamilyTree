require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  def setup
    # Create roles if they don't exist
    Role.find_or_create_by(name: 'admin')
    Role.find_or_create_by(name: 'gold')
    Role.find_or_create_by(name: 'silver')
    Role.find_or_create_by(name: 'bronze')
    
    @admin_user = users(:one)
    @admin_user.add_role(:admin)
    
    # Create test people for events
    @person1 = Person.create!(
      name: "Test Person One",
      birth_year: 1980,
      birth_month: 5,
      birth_day: 15
    )
    
    @person2 = Person.create!(
      name: "Test Person Two",
      birth_year: 1985,
      birth_month: 8,
      birth_day: 20
    )
    
    # Create test events
    @event1 = Event.create!(
      name: "person.create",
      data: { name: "Test Person One", birth_year: 1980 },
      user: @admin_user,
      resource: @person1
    )
    
    @event2 = Event.create!(
      name: "person.update",
      data: { name: ["Old Name", "New Name"] },
      user: @admin_user,
      resource: @person2
    )
    
    @event3 = Event.create!(
      name: "user.create",
      data: { email: "test@example.com" },
      user: @admin_user
    )
  end

  test "should download events CSV with admin user" do
    sign_in_as(@admin_user)
    
    get download_events_path(format: :csv)
    
    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_includes response.headers['Content-Disposition'], 'events'
    assert_includes response.headers['Content-Disposition'], Date.today.to_s
    
    # Verify CSV contains event data
    csv_data = response.body
    assert_includes csv_data, "person.create"
    assert_includes csv_data, "person.update"
    assert_includes csv_data, "user.create"
    assert_includes csv_data, @admin_user.id.to_s
  end

  test "should order events by id in CSV download" do
    sign_in_as(@admin_user)
    
    # Create events with known order
    Event.delete_all
    first_event = Event.create!(
      name: "first.event",
      data: { order: 1 },
      user: @admin_user
    )
    second_event = Event.create!(
      name: "second.event", 
      data: { order: 2 },
      user: @admin_user
    )
    
    get download_events_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # Verify ordering by checking positions in CSV
    first_pos = csv_data.index("first.event")
    second_pos = csv_data.index("second.event")
    
    assert_not_nil first_pos
    assert_not_nil second_pos
    assert first_pos < second_pos, "Events should be ordered by ID"
  end

  test "should handle empty events collection" do
    sign_in_as(@admin_user)
    
    # Delete all events
    Event.delete_all
    
    get download_events_path(format: :csv)
    
    assert_response :success
    assert_equal "text/csv", response.media_type
    
    # Should contain only headers
    csv_data = response.body
    lines = csv_data.split("\n")
    assert_equal 1, lines.length, "Should only contain header line"
    assert_includes lines.first, "name" # Should have column headers
  end

  test "should require authentication" do
    get download_events_path(format: :csv)
    assert_response :unauthorized
  end

  test "should require admin authorization" do
    # Test with a user who doesn't have admin role
    non_admin_user = User.create!(
      name: "Non Admin User",
      email: "nonadmin@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    non_admin_user.add_role(:bronze) # Bronze role doesn't have access
    
    sign_in_as(non_admin_user)
    
    get download_events_path(format: :csv)
    assert_response :redirect # Should redirect due to authorization failure
  end

  test "should handle authorization with gold user" do
    # Test with gold user (not admin)
    gold_user = User.create!(
      name: "Gold User",
      email: "gold@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    gold_user.add_role(:gold)
    
    sign_in_as(gold_user)
    
    get download_events_path(format: :csv)
    assert_response :redirect # Should redirect since only admin can download
  end

  test "should handle authorization with silver user" do
    # Test with silver user (not admin)
    silver_user = User.create!(
      name: "Silver User",
      email: "silver@example.com", 
      password: "password",
      confirmed_at: 1.week.ago
    )
    silver_user.add_role(:silver)
    
    sign_in_as(silver_user)
    
    get download_events_path(format: :csv)
    assert_response :redirect # Should redirect since only admin can download
  end

  test "should include all event types in CSV" do
    sign_in_as(@admin_user)
    
    # Clear existing events and create specific test events
    Event.delete_all
    
    event_types = [
      "person.create",
      "person.update", 
      "person.unlink",
      "couple.create",
      "couple.update",
      "couple.unlink", 
      "child.create",
      "child.unlink",
      "user.create"
    ]
    
    event_types.each_with_index do |event_type, index|
      Event.create!(
        name: event_type,
        data: { test_data: "data_#{index}" },
        user: @admin_user,
        resource: index.even? ? @person1 : @person2
      )
    end
    
    get download_events_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # Verify all event types are included
    event_types.each do |event_type|
      assert_includes csv_data, event_type, "CSV should contain #{event_type}"
    end
  end

  test "should include event data and metadata in CSV" do
    sign_in_as(@admin_user)
    
    # Create event with complex data
    complex_event = Event.create!(
      name: "complex.event",
      data: {
        "changes" => {
          "name" => ["Old Name", "New Name"],
          "birth_year" => [1980, 1985]
        },
        "metadata" => {
          "source" => "admin_panel",
          "timestamp" => Time.current.iso8601
        }
      },
      user: @admin_user,
      resource: @person1
    )
    
    get download_events_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # Verify complex data is serialized in CSV
    assert_includes csv_data, "complex.event"
    assert_includes csv_data, @admin_user.id.to_s
    assert_includes csv_data, @person1.id.to_s
    assert_includes csv_data, "Person" # resource_type
  end

  test "should handle events with different resource types" do
    sign_in_as(@admin_user)
    
    # Create couple for testing
    couple = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max
    )
    
    # Clear existing events
    Event.delete_all
    
    # Create events with different resource types
    person_event = Event.create!(
      name: "person.test",
      data: { test: "person" },
      user: @admin_user,
      resource: @person1
    )
    
    couple_event = Event.create!(
      name: "couple.test",
      data: { test: "couple" },
      user: @admin_user,
      resource: couple
    )
    
    no_resource_event = Event.create!(
      name: "system.test",
      data: { test: "system" },
      user: @admin_user
    )
    
    get download_events_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # Verify all events are included
    assert_includes csv_data, "person.test"
    assert_includes csv_data, "couple.test"
    assert_includes csv_data, "system.test"
    
    # Verify resource types
    assert_includes csv_data, "Person"
    assert_includes csv_data, "Couple"
  end

  test "should handle events with nil resource" do
    sign_in_as(@admin_user)
    
    # Create event without resource
    Event.create!(
      name: "system.event",
      data: { system: "maintenance" },
      user: @admin_user,
      resource: nil
    )
    
    get download_events_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    assert_includes csv_data, "system.event"
    # Should handle nil resource gracefully
  end

  test "should handle large number of events" do
    sign_in_as(@admin_user)
    
    # Clear existing events
    Event.delete_all
    
    # Create many events to test performance
    100.times do |i|
      Event.create!(
        name: "bulk.event.#{i}",
        data: { sequence: i, batch: "large_test" },
        user: @admin_user,
        resource: i.even? ? @person1 : @person2
      )
    end
    
    get download_events_path(format: :csv)
    
    assert_response :success
    assert_equal "text/csv", response.media_type
    
    csv_data = response.body
    lines = csv_data.split("\n")
    
    # Should have header + 100 data lines
    assert_equal 101, lines.length
    
    # Verify first and last events are included
    assert_includes csv_data, "bulk.event.0"
    assert_includes csv_data, "bulk.event.99"
  end

  test "should set correct Content-Disposition header" do
    sign_in_as(@admin_user)
    
    get download_events_path(format: :csv)
    
    assert_response :success
    
    content_disposition = response.headers['Content-Disposition']
    assert_not_nil content_disposition
    assert_includes content_disposition, 'attachment'
    assert_includes content_disposition, 'events'
    assert_includes content_disposition, Date.today.to_s
    assert_includes content_disposition, '.csv'
  end

  test "should only respond to CSV format" do
    sign_in_as(@admin_user)
    
    # Test non-CSV format
    assert_raises(ActionController::UnknownFormat) do
      get download_events_path(format: :html)
    end
    
    assert_raises(ActionController::UnknownFormat) do
      get download_events_path(format: :json)
    end
  end

  test "CSV headers should match Event model columns" do
    sign_in_as(@admin_user)
    
    get download_events_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    headers = csv_data.split("\n").first.split(";")
    
    # Should include main Event model columns
    expected_columns = %w[id name user_id data created_at resource_type resource_id]
    
    expected_columns.each do |column|
      assert_includes headers, column, "CSV should include #{column} column"
    end
  end

  test "should handle events from different users" do
    sign_in_as(@admin_user)
    
    # Create another user
    another_user = User.create!(
      name: "Another User",
      email: "another@example.com",
      password: "password", 
      confirmed_at: 1.week.ago
    )
    
    # Clear existing events
    Event.delete_all
    
    # Create events from different users
    Event.create!(
      name: "admin.event",
      data: { user: "admin" },
      user: @admin_user
    )
    
    Event.create!(
      name: "other.event", 
      data: { user: "other" },
      user: another_user
    )
    
    get download_events_path(format: :csv)
    
    assert_response :success
    csv_data = response.body
    
    # Should include events from all users
    assert_includes csv_data, "admin.event"
    assert_includes csv_data, "other.event"
    assert_includes csv_data, @admin_user.id.to_s
    assert_includes csv_data, another_user.id.to_s
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