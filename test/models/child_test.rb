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

    @child_person = Person.create!(
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

  test "Child is an ActiveRecord model" do
    assert Child < ApplicationRecord
  end

  test "Child model includes correct modules" do
    assert Child.include?(GenerateCsv)
  end

  test "Child has correct table name" do
    assert_equal 'couples_people', Child.table_name
  end

  test "Child belongs to couple" do
    child = Child.create!(person_id: @child_person.id, couple_id: @couple.id)
    assert_equal @couple, child.couple
  end

  test "Child belongs to person" do
    child = Child.create!(person_id: @child_person.id, couple_id: @couple.id)
    assert_equal @child_person, child.person
  end

  test "Child validates uniqueness of person_id scoped to couple_id" do
    # Create first child relationship
    Child.create!(person_id: @child_person.id, couple_id: @couple.id)

    # Try to create duplicate
    duplicate = Child.new(person_id: @child_person.id, couple_id: @couple.id)
    assert_not duplicate.valid?
    assert duplicate.errors[:person_id].present?
  end

  test "Child can be created with valid attributes" do
    assert_difference('Child.count', 1) do
      Child.create!(person_id: @child_person.id, couple_id: @couple.id)
    end
  end

  test "Child.all returns all child relationships" do
    # Create some child relationships
    child1 = Child.create!(person_id: @child_person.id, couple_id: @couple.id)

    another_person = Person.create!(name: "Another Child", birth_year: 2012)
    child2 = Child.create!(person_id: another_person.id, couple_id: @couple.id)

    children = Child.all
    assert children.exists?(person_id: child1.person_id, couple_id: child1.couple_id)
    assert children.exists?(person_id: child2.person_id, couple_id: child2.couple_id)
  end

  test "Child.where(couple_id:) returns children of specific couple" do
    child = Child.create!(person_id: @child_person.id, couple_id: @couple.id)

    children = Child.where(couple_id: @couple.id)
    assert children.exists?(person_id: child.person_id, couple_id: child.couple_id)
  end

  test "Child.where(person_id:) returns couples where person is a child" do
    child = Child.create!(person_id: @child_person.id, couple_id: @couple.id)

    parent_couples = Child.where(person_id: @child_person.id)
    assert parent_couples.exists?(person_id: child.person_id, couple_id: child.couple_id)
  end

  test "after_create callback creates event when current_user is set" do
    child = Child.new(person_id: @child_person.id, couple_id: @couple.id)
    child.current_user = @user

    assert_difference('Event.count', 1) do
      child.save!
    end

    event = Event.last
    assert_equal 'child.create', event.name
    assert_equal @child_person, event.resource
    assert_equal @user, event.user
    assert_equal @couple.id, event.data['couple_id']
    assert_equal @child_person.id, event.data['person_id']
  end

  test "after_create callback creates event with system user when current_user is nil" do
    child = Child.new(person_id: @child_person.id, couple_id: @couple.id)
    child.current_user = nil

    assert_difference('Event.count', 1) do
      child.save!
    end

    event = Event.last
    assert_equal 'child.create', event.name
    assert_equal @child_person, event.resource
    assert_equal User.system_user, event.user
    assert_equal @couple.id, event.data['couple_id']
    assert_equal @child_person.id, event.data['person_id']
  end

  test "after_destroy callback creates event when current_user is set" do
    child = Child.create!(person_id: @child_person.id, couple_id: @couple.id)
    child.current_user = @user

    assert_difference('Event.count', 1) do
      child.destroy!
    end

    event = Event.last
    assert_equal 'child.unlink', event.name
    assert_equal @child_person, event.resource
    assert_equal @user, event.user
    assert_equal @couple.id, event.data['couple_id']
    assert_equal @child_person.id, event.data['person_id']
  end

  test "after_destroy callback creates event with system user when current_user is nil" do
    child = Child.create!(person_id: @child_person.id, couple_id: @couple.id)
    child.current_user = nil

    assert_difference('Event.count', 1) do
      child.destroy!
    end

    event = Event.last
    assert_equal 'child.unlink', event.name
    assert_equal @child_person, event.resource
    assert_equal User.system_user, event.user
    assert_equal @couple.id, event.data['couple_id']
    assert_equal @child_person.id, event.data['person_id']
  end

  test "Child inherits CSV generation from GenerateCsv" do
    assert_respond_to Child, :to_csv
  end

  test "Child.to_csv generates CSV with correct headers and data" do
    Child.create!(person_id: @child_person.id, couple_id: @couple.id)

    children = Child.all
    csv_data = Child.to_csv(children)

    # Check CSV structure
    lines = csv_data.split("\n")
    assert_not_empty lines

    # Check that data is included
    assert csv_data.include?(@child_person.id.to_s)
    assert csv_data.include?(@couple.id.to_s)
  end

  test "Child.to_csv handles empty collection" do
    empty_collection = Child.none
    csv_data = Child.to_csv(empty_collection)

    # Should only contain headers
    lines = csv_data.split("\n")
    assert_equal 1, lines.length
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
    child1 = Child.create!(person_id: @child_person.id, couple_id: @couple.id)
    child2 = Child.create!(person_id: another_child.id, couple_id: @couple.id)

    children = Child.where(couple_id: @couple.id)

    # Should have records for both children
    assert children.exists?(person_id: child1.person_id, couple_id: child1.couple_id)
    assert children.exists?(person_id: child2.person_id, couple_id: child2.couple_id)
    assert_equal 2, children.count
  end

  test "Child model works with child having multiple couples (e.g., adoption)" do
    # Create another couple
    parent3 = Person.create!(name: "Parent Three", birth_year: 1985)
    parent4 = Person.create!(name: "Parent Four", birth_year: 1987)

    another_couple = Couple.create!(
      person1_id: [parent3.id, parent4.id].min,
      person2_id: [parent3.id, parent4.id].max
    )

    # Add same child to both couples
    child1 = Child.create!(person_id: @child_person.id, couple_id: @couple.id)
    child2 = Child.create!(person_id: @child_person.id, couple_id: another_couple.id)

    parent_couples = Child.where(person_id: @child_person.id)

    # Should have records for the same child in both couples
    assert parent_couples.exists?(person_id: child1.person_id, couple_id: child1.couple_id)
    assert parent_couples.exists?(person_id: child2.person_id, couple_id: child2.couple_id)
    assert_equal 2, parent_couples.count
  end

  test "destroying Child removes relationship from couples_people table" do
    child = Child.create!(person_id: @child_person.id, couple_id: @couple.id)

    assert_difference('Child.count', -1) do
      child.destroy!
    end

    assert_not Child.exists?(person_id: @child_person.id, couple_id: @couple.id)
  end

  test "Child can access person and couple associations efficiently" do
    child = Child.create!(person_id: @child_person.id, couple_id: @couple.id)

    # Test associations work
    assert_equal @child_person.name, child.person.name
    assert_equal @couple.person1_id, child.couple.person1_id
    assert_equal @couple.person2_id, child.couple.person2_id
  end

  test "event data includes both couple_id and person_id" do
    child = Child.new(person_id: @child_person.id, couple_id: @couple.id)
    child.current_user = @user
    child.save!

    event = Event.last
    assert_equal @couple.id, event.data['couple_id']
    assert_equal @child_person.id, event.data['person_id']
  end
end
