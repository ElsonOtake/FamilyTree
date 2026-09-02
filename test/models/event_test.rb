# frozen_string_literal: true

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @person = Person.create!(
      name: 'Test Person',
      birth_year: 1990,
      birth_month: 5,
      birth_day: 15
    )
  end

  test 'Event belongs to user' do
    event = Event.new(
      name: 'test.action',
      data: { test: 'data' },
      user: @user
    )

    assert_equal @user, event.user
    assert_respond_to event, :user
  end

  test 'Event belongs to polymorphic resource' do
    event = Event.new(
      name: 'test.action',
      data: { test: 'data' },
      user: @user,
      resource: @person
    )

    assert_equal @person, event.resource
    assert_equal 'Person', event.resource_type
    assert_equal @person.id, event.resource_id
    assert_respond_to event, :resource
  end

  test 'Event can be created without resource (optional)' do
    event = Event.create!(
      name: 'test.action',
      data: { test: 'data' },
      user: @user
    )

    assert event.persisted?
    assert_nil event.resource
    assert_nil event.resource_type
    assert_nil event.resource_id
  end

  test 'Event validates presence of name' do
    event = Event.new(
      data: { test: 'data' },
      user: @user
    )

    assert_not event.valid?
    assert_includes event.errors[:name], 'não pode ficar em branco'
  end

  test 'Event validates presence of data' do
    event = Event.new(
      name: 'test.action',
      user: @user
    )

    assert_not event.valid?
    assert_includes event.errors[:data], 'não pode ficar em branco'
  end

  test 'Event requires user association' do
    event = Event.new(
      name: 'test.action',
      data: { test: 'data' }
    )

    assert_not event.valid?
    assert_includes event.errors[:user], 'é obrigatório(a)'
  end

  test 'Event can be created with valid attributes' do
    event = Event.create!(
      name: 'person.create',
      data: { name: 'John Doe', birth_year: 1985 },
      user: @user,
      resource: @person
    )

    assert event.persisted?
    assert_equal 'person.create', event.name
    assert_equal({ 'name' => 'John Doe', 'birth_year' => 1985 }, event.data)
    assert_equal @user, event.user
    assert_equal @person, event.resource
  end

  test 'Event data field stores JSON' do
    complex_data = {
      'changes' => {
        'name' => ['Old Name', 'New Name'],
        'birth_year' => [1980, 1985]
      },
      'metadata' => {
        'source' => 'admin_panel',
        'timestamp' => Time.current.iso8601
      }
    }

    event = Event.create!(
      name: 'person.update',
      data: complex_data,
      user: @user,
      resource: @person
    )

    event.reload
    assert_equal complex_data, event.data
    assert event.data.is_a?(Hash)
  end

  test 'user_created scope returns only user.create events' do
    # Clear existing events to ensure clean test
    Event.delete_all

    # Create different types of events
    Event.create!(name: 'user.create', data: { email: 'test1@example.com' }, user: @user)
    Event.create!(name: 'user.create', data: { email: 'test2@example.com' }, user: @user)
    Event.create!(name: 'person.create', data: { name: 'Person' }, user: @user)
    Event.create!(name: 'couple.create', data: { marriage: '2023-01-01' }, user: @user)

    user_create_events = Event.user_created

    assert_equal 2, user_create_events.count
    user_create_events.each do |event|
      assert_equal 'user.create', event.name
    end
  end

  test 'ransackable_attributes returns correct attributes' do
    ransackable_attrs = Event.ransackable_attributes

    expected_attrs = %w[name user_id resource_type resource_id created_at]
    assert_equal expected_attrs, ransackable_attrs
  end

  test 'ransackable_associations returns empty array' do
    ransackable_assocs = Event.ransackable_associations

    assert_equal [], ransackable_assocs
  end

  test 'Event works with different resource types' do
    # Create another person
    another_person = Person.create!(name: 'Another Person', birth_year: 1995)

    # Create couple
    couple = Couple.create!(
      person1_id: [@person.id, another_person.id].min,
      person2_id: [@person.id, another_person.id].max
    )

    # Test with Person resource
    person_event = Event.create!(
      name: 'person.create',
      data: { name: 'Test Person' },
      user: @user,
      resource: @person
    )

    # Test with Couple resource
    couple_event = Event.create!(
      name: 'couple.create', 
      data: { marriage: '2023-01-01' },
      user: @user,
      resource: couple
    )

    assert_equal 'Person', person_event.resource_type
    assert_equal @person.id, person_event.resource_id
    assert_equal @person, person_event.resource

    assert_equal 'Couple', couple_event.resource_type
    assert_equal couple.id, couple_event.resource_id
    assert_equal couple, couple_event.resource
  end

  test 'Event stores different action types correctly' do
    # Clear existing events to ensure clean test
    Event.delete_all

    action_types = [
      'person.create',
      'person.update',
      'person.unlink',
      'couple.create',
      'couple.update',
      'couple.unlink',
      'child.create',
      'child.unlink',
      'user.create'
    ]

    action_types.each do |action|
      event = Event.create!(
        name: action,
        data: { action_type: action },
        user: @user,
        resource: @person
      )

      assert event.persisted?
      assert_equal action, event.name
    end

    assert_equal action_types.length, Event.count
  end

  test 'Event can store RecordEvent callback data' do
    # Simulate data from RecordEvent concern
    changes_data = {
      'name' => ['Old Name', 'New Name'],
      'birth_year' => [1980, 1985],
      'birth_month' => [nil, 5]
    }

    event = Event.create!(
      name: 'person.update',
      data: changes_data,
      user: @user,
      resource: @person
    )

    assert event.persisted?
    assert_equal changes_data, event.data
    assert_equal 'person.update', event.name
  end

  test 'Event can store Child registration data' do
    # Simulate data from Child.register_event
    child_data = {
      'couple_id' => 123
    }

    event = Event.create!(
      name: 'child.create',
      data: child_data,
      user: @user,
      resource: @person
    )

    assert event.persisted?
    assert_equal child_data, event.data
    assert_equal 'child.create', event.name
    assert_equal @person, event.resource
  end

  test 'Event creation timestamp is automatically set' do
    event = Event.create!(
      name: 'test.action',
      data: { test: 'data' },
      user: @user
    )

    assert_not_nil event.created_at
    assert event.created_at <= Time.current
    assert event.created_at >= 1.minute.ago
  end

  test 'Event queries work correctly' do
    # Create events with different users
    another_user = User.create!(
      name: 'Another User',
      email: 'another@example.com',
      password: 'password',
      confirmed_at: 1.week.ago
    )

    user1_event = Event.create!(
      name: 'person.create',
      data: { test: 'user1' },
      user: @user
    )

    user2_event = Event.create!(
      name: 'person.create', 
      data: { test: 'user2' },
      user: another_user
    )

    # Query by user
    user1_events = Event.where(user: @user)
    user2_events = Event.where(user: another_user)

    assert_includes user1_events, user1_event
    assert_not_includes user1_events, user2_event

    assert_includes user2_events, user2_event
    assert_not_includes user2_events, user1_event
  end

  test 'Event handles empty data hash' do
    event = Event.new(
      name: 'test.action',
      data: {},
      user: @user
    )

    # Empty hash should not be valid based on the validation error
    assert_not event.valid?
    assert_includes event.errors[:data], 'não pode ficar em branco'
  end

  test 'Event data default value is empty hash' do
    # Create event without explicitly setting data
    event = Event.new(
      name: 'test.action',
      user: @user
    )

    # Should have default empty hash but will fail validation
    assert_equal({}, event.data)
    assert_not event.valid?
    assert_includes event.errors[:data], 'não pode ficar em branco'
  end
end
