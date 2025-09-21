require "test_helper"

class ChildTest < ActiveSupport::TestCase
  def setup
    # Create test people
    @parent1 = Person.create!(
      name: "Parent One",
      birth_year: 1980,
      birth_month: 5,
      birth_day: 15
    )
    
    @parent2 = Person.create!(
      name: "Parent Two", 
      birth_year: 1982,
      birth_month: 8,
      birth_day: 20
    )
    
    @child = Person.create!(
      name: "Test Child",
      birth_year: 2010,
      birth_month: 3,
      birth_day: 10
    )
    
    # Create a couple
    @couple = Couple.create!(
      person1_id: [@parent1.id, @parent2.id].min,
      person2_id: [@parent1.id, @parent2.id].max
    )
    
    # Create a user for event testing
    @user = users(:one)
  end

  test "Child model includes correct modules" do
    assert Child.include?(GenerateCsv)
    assert Child.include?(ActiveModel::Model)
    assert Child.include?(ActiveModel::Attributes)
  end

  test "Child has correct attributes" do
    child = Child.new
    assert_respond_to child, :person_id
    assert_respond_to child, :couple_id
    assert_respond_to child, :person_id=
    assert_respond_to child, :couple_id=
  end

  test "Child can be instantiated and attributes can be set" do
    child = Child.new
    child.person_id = 123
    child.couple_id = 456
    assert_equal 123, child.person_id
    assert_equal 456, child.couple_id
  end

  test "Child.all returns Person.joins(:couples) with correct select" do
    # Add child to couple first
    @couple.people << @child
    
    children = Child.all
    
    # Should return objects with person_id and couple_id columns
    assert_not_empty children
    
    # Check that it includes our test data
    child_records = children.to_a
    assert child_records.any? { |record| record.person_id == @child.id && record.couple_id == @couple.id }
  end

  test "Child.all returns empty collection when no children exist" do
    # Ensure no children exist by clearing all couple-person relationships
    Person.joins(:couples).delete_all
    
    children = Child.all
    assert_empty children
  end

  test "Child.column_names returns attribute names" do
    column_names = Child.column_names
    assert_includes column_names, "person_id"
    assert_includes column_names, "couple_id"
    assert_equal 2, column_names.length
  end

  test "register_event creates an event with correct attributes" do
    child_model = Child.new(person_id: @child.id, couple_id: @couple.id)
    
    assert_difference('Event.count', 1) do
      child_model.register_event(@child, @couple, @user, 'test.action')
    end
    
    event = Event.last
    assert_equal 'test.action', event.name
    assert_equal @child, event.resource
    assert_equal @user, event.user
    assert_equal @couple.id, event.data['couple_id']
  end

  test "register_event handles different action types" do
    child_model = Child.new(person_id: @child.id, couple_id: @couple.id)
    
    # Test child.create action
    child_model.register_event(@child, @couple, @user, 'child.create')
    create_event = Event.last
    assert_equal 'child.create', create_event.name
    
    # Test child.unlink action
    child_model.register_event(@child, @couple, @user, 'child.unlink')
    unlink_event = Event.last
    assert_equal 'child.unlink', unlink_event.name
    
    # Test custom action
    child_model.register_event(@child, @couple, @user, 'child.custom')
    custom_event = Event.last
    assert_equal 'child.custom', custom_event.name
  end

  test "register_event stores correct data structure" do
    child_model = Child.new(person_id: @child.id, couple_id: @couple.id)
    
    child_model.register_event(@child, @couple, @user, 'test.action')
    
    event = Event.last
    assert event.data.is_a?(Hash)
    assert_equal @couple.id, event.data['couple_id']
    assert_equal 1, event.data.keys.length # Only couple_id should be stored
  end

  test "register_event creates event associated with correct user" do
    # Create another user
    another_user = User.create!(
      name: "Another User",
      email: "another@example.com",
      password: "password",
      confirmed_at: 1.week.ago
    )
    
    child_model = Child.new(person_id: @child.id, couple_id: @couple.id)
    
    child_model.register_event(@child, @couple, another_user, 'test.action')
    
    event = Event.last
    assert_equal another_user, event.user
    assert_not_equal @user, event.user
  end

  test "Child inherits CSV generation from GenerateCsv" do
    assert_respond_to Child, :to_csv
  end

  test "Child.to_csv generates CSV with correct headers and data" do
    # Add child to couple
    @couple.people << @child
    
    children = Child.all
    csv_data = Child.to_csv(children)
    
    # Check CSV structure
    lines = csv_data.split("\n")
    headers = lines.first.split(";")
    
    assert_includes headers, "person_id"
    assert_includes headers, "couple_id"
    
    # Check that data is included
    assert csv_data.include?(@child.id.to_s)
    assert csv_data.include?(@couple.id.to_s)
  end

  test "Child.to_csv handles empty collection" do
    empty_collection = []
    csv_data = Child.to_csv(empty_collection)
    
    # Should only contain headers
    lines = csv_data.split("\n")
    assert_equal 1, lines.length
    assert_includes lines.first, "person_id"
    assert_includes lines.first, "couple_id"
  end

  test "Child model works with multiple children for same couple" do
    # Create another child
    another_child = Person.create!(
      name: "Another Child",
      birth_year: 2012,
      birth_month: 7,
      birth_day: 5
    )
    
    # Add both children to the couple
    @couple.people << @child
    @couple.people << another_child
    
    children = Child.all
    child_records = children.to_a
    
    # Should have records for both children
    assert child_records.any? { |record| record.person_id == @child.id && record.couple_id == @couple.id }
    assert child_records.any? { |record| record.person_id == another_child.id && record.couple_id == @couple.id }
  end

  test "Child model works with child having multiple couples" do
    # Create another couple
    parent3 = Person.create!(name: "Parent Three", birth_year: 1985)
    parent4 = Person.create!(name: "Parent Four", birth_year: 1987)
    
    another_couple = Couple.create!(
      person1_id: [parent3.id, parent4.id].min,
      person2_id: [parent3.id, parent4.id].max
    )
    
    # Add same child to both couples
    @couple.people << @child
    another_couple.people << @child
    
    children = Child.all
    child_records = children.to_a
    
    # Should have records for the same child in both couples
    assert child_records.any? { |record| record.person_id == @child.id && record.couple_id == @couple.id }
    assert child_records.any? { |record| record.person_id == @child.id && record.couple_id == another_couple.id }
  end
end