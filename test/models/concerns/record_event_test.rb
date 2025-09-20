require "test_helper"

class RecordEventTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @person = people(:one)
    @person2 = people(:two)
    
    # Create a test class that includes RecordEvent for Couple-like behavior
    @couple_test_class = Class.new(ActiveRecord::Base) do
      self.table_name = 'couples'
      include RecordEvent
      
      belongs_to :person1, class_name: 'Person', foreign_key: 'person1_id'
      belongs_to :person2, class_name: 'Person', foreign_key: 'person2_id'
    end
  end

  # INITIALIZATION TESTS
  test "concern adds current_user attribute accessor" do
    test_instance = @couple_test_class.new
    assert_respond_to test_instance, :current_user
    assert_respond_to test_instance, :current_user=
  end

  test "concern adds after_create callback" do
    callbacks = @couple_test_class._create_callbacks.map(&:filter)
    assert_includes callbacks, :record_create
  end

  test "concern adds after_update callback" do
    callbacks = @couple_test_class._update_callbacks.map(&:filter)
    assert_includes callbacks, :record_update
  end

  test "concern adds after_destroy callback" do
    callbacks = @couple_test_class._destroy_callbacks.map(&:filter)
    assert_includes callbacks, :record_destroy
  end

  # RECORD_CREATE TESTS FOR PERSON
  test "record_create creates event for Person when current_user is set" do
    @person.current_user = @user
    
    assert_difference '@user.events.count', 1 do
      @person.save!
    end
    
    event = @user.events.last
    assert_equal 'person.create', event.name
    assert_equal @person, event.resource
    assert_not_nil event.data
  end

  test "record_create does not create event for Person when current_user is nil" do
    @person.current_user = nil
    
    assert_no_difference 'Event.count' do
      new_person = Person.create!(name: "Test Person", birth_year: 1990)
    end
  end

  test "record_create filters out nil and empty values from changes" do
    @person.current_user = @user
    @person.name = "Updated Name"
    @person.phone = nil  # Should be filtered out
    @person.save!
    
    event = @user.events.last
    # Should not include phone field if it's nil
    assert_not_includes event.data.keys, 'phone' if @person.phone.nil?
  end

  test "record_create filters out id and updated_at fields" do
    @person.current_user = @user
    @person.name = "Updated Name"
    @person.save!
    
    event = @user.events.last
    assert_not_includes event.data.keys, 'id'
    assert_not_includes event.data.keys, 'updated_at'
  end

  # RECORD_CREATE TESTS FOR NON-PERSON (COUPLE-LIKE)
  test "record_create creates two events for non-Person models" do
    couple = @couple_test_class.new(
      person1_id: @person.id,
      person2_id: @person2.id,
      marriage_date: Date.current
    )
    couple.current_user = @user
    
    assert_difference '@user.events.count', 2 do
      couple.save!
    end
    
    events = @user.events.last(2)
    assert_equal 'couples', events.first.name.split('.').first
    assert_equal 'create', events.first.name.split('.').last
    assert_equal @person, events.first.resource
    assert_equal @person2, events.last.resource
  end

  # RECORD_UPDATE TESTS FOR PERSON
  test "record_update creates event for Person when current_user is set" do
    @person.current_user = @user
    
    assert_difference '@user.events.count', 1 do
      @person.update!(name: "Updated Name")
    end
    
    event = @user.events.last
    assert_equal 'person.update', event.name
    assert_equal @person, event.resource
    assert_includes event.data.keys, 'name'
  end

  test "record_update captures saved_changes correctly" do
    @person.current_user = @user
    old_name = @person.name
    new_name = "Updated Name"
    
    @person.update!(name: new_name)
    
    event = @user.events.last
    assert_equal [old_name, new_name], event.data['name']
  end

  test "record_update does not create event when current_user is nil" do
    @person.current_user = nil
    
    assert_no_difference 'Event.count' do
      @person.update!(name: "Updated Name")
    end
  end

  # RECORD_UPDATE TESTS FOR NON-PERSON (COUPLE-LIKE)
  test "record_update creates two events for non-Person models" do
    couple = @couple_test_class.create!(
      person1_id: @person.id,
      person2_id: @person2.id,
      marriage_date: Date.current
    )
    couple.current_user = @user
    
    assert_difference '@user.events.count', 2 do
      couple.update!(marriage_date: Date.yesterday)
    end
    
    events = @user.events.last(2)
    assert_equal 'couples', events.first.name.split('.').first
    assert_equal 'update', events.first.name.split('.').last
    assert_equal @person, events.first.resource
    assert_equal @person2, events.last.resource
  end

  # RECORD_DESTROY TESTS
  test "record_destroy creates events when record is soft deleted and current_user is set" do
    # Create a couple with paranoia (soft delete)
    couple = Couple.create!(
      person1_id: @person.id,
      person2_id: @person2.id,
      marriage_date: Date.current
    )
    couple.current_user = @user
    
    assert_difference '@user.events.count', 2 do
      couple.destroy # This should soft delete
    end
    
    events = @user.events.last(2)
    assert_equal 'couple.unlink', events.first.name
    assert_equal 'couple.unlink', events.last.name
    assert_equal @person, events.first.resource
    assert_equal @person2, events.last.resource
    assert_not_nil events.first.data['deleted_at']
  end

  test "record_destroy does not create events when current_user is nil" do
    couple = Couple.create!(
      person1_id: @person.id,
      person2_id: @person2.id,
      marriage_date: Date.current
    )
    couple.current_user = nil
    
    assert_no_difference 'Event.count' do
      couple.destroy
    end
  end

  test "record_destroy only triggers for logical deletion (soft delete)" do
    couple = Couple.create!(
      person1_id: @person.id,
      person2_id: @person2.id,
      marriage_date: Date.current
    )
    couple.current_user = @user
    
    # Mock destroyed_logically? to return false
    couple.define_singleton_method(:destroyed_logically?) { false }
    
    assert_no_difference '@user.events.count' do
      couple.destroy
    end
  end

  # DESTROYED_LOGICALLY? PRIVATE METHOD TESTS
  test "destroyed_logically? returns true when deleted_at is present" do
    couple = @couple_test_class.new
    couple.deleted_at = Time.current
    
    assert couple.send(:destroyed_logically?)
  end

  test "destroyed_logically? returns false when deleted_at is nil" do
    couple = @couple_test_class.new
    couple.deleted_at = nil
    
    assert_not couple.send(:destroyed_logically?)
  end

  # EVENT DATA CONTENT TESTS
  test "create events contain filtered saved_changes" do
    @person.current_user = @user
    @person.name = "New Name"
    @person.birth_year = 1990
    @person.save!
    
    event = @user.events.last
    # Should contain the changes but filtered
    assert_includes event.data.keys, 'name'
    assert_includes event.data.keys, 'birth_year'
    # Should be the final values, not change arrays
    assert_equal "New Name", event.data['name']
    assert_equal 1990, event.data['birth_year']
  end

  test "update events contain change arrays" do
    @person.current_user = @user
    old_name = @person.name
    new_name = "Updated Name"
    
    @person.update!(name: new_name)
    
    event = @user.events.last
    # Should contain before/after arrays
    assert_equal [old_name, new_name], event.data['name']
  end

  test "destroy events contain deleted_at timestamp" do
    couple = Couple.create!(
      person1_id: @person.id,
      person2_id: @person2.id,
      marriage_date: Date.current
    )
    couple.current_user = @user
    
    couple.destroy
    
    events = @user.events.last(2)
    events.each do |event|
      assert_includes event.data.keys, 'deleted_at'
      assert_not_nil event.data['deleted_at']
    end
  end

  # ERROR HANDLING TESTS
  test "handles missing person1_id gracefully in non-Person models" do
    couple = @couple_test_class.new(person2_id: @person2.id)
    couple.current_user = @user
    
    # Should handle the case where Person.find(nil) might fail
    assert_raises(ActiveRecord::RecordNotFound) do
      couple.save!
    end
  end

  test "handles missing person2_id gracefully in non-Person models" do
    couple = @couple_test_class.new(person1_id: @person.id)
    couple.current_user = @user
    
    # Should handle the case where Person.find(nil) might fail
    assert_raises(ActiveRecord::RecordNotFound) do
      couple.save!
    end
  end

  # CLASS DETECTION TESTS
  test "correctly identifies Person class vs non-Person class" do
    # Person should follow one path
    @person.current_user = @user
    @person.save!
    
    person_event = @user.events.last
    assert_equal 'person.create', person_event.name
    assert_equal @person, person_event.resource
    
    # Non-Person should follow different path
    couple = @couple_test_class.create!(
      person1_id: @person.id,
      person2_id: @person2.id
    )
    couple.current_user = @user
    couple.update!(marriage_date: Date.current)
    
    couple_events = @user.events.last(2)
    assert_equal 'couples.update', couple_events.first.name
    assert_not_equal couple, couple_events.first.resource # Should be Person, not Couple
  end

  # INTEGRATION WITH ACTIVEMODEL::DIRTY
  test "concern includes ActiveModel::Dirty" do
    assert @couple_test_class.ancestors.include?(ActiveModel::Dirty)
  end

  test "uses saved_changes from ActiveModel::Dirty" do
    @person.current_user = @user
    @person.name = "Changed Name"
    @person.save!
    
    # Should have access to saved_changes
    assert_respond_to @person, :saved_changes
  end

  # EVENT NAME GENERATION TESTS
  test "generates correct event names using class name underscore" do
    @person.current_user = @user
    @person.save!
    
    event = @user.events.last
    assert_equal 'person.create', event.name
    
    couple = @couple_test_class.create!(
      person1_id: @person.id,
      person2_id: @person2.id
    )
    couple.current_user = @user
    couple.update!(marriage_date: Date.current)
    
    couple_event = @user.events.last
    assert_includes couple_event.name, 'couples'
  end

  # MULTIPLE OPERATIONS TESTS
  test "handles multiple operations on same record" do
    @person.current_user = @user
    
    # Create
    @person.save!
    create_event = @user.events.last
    
    # Update
    @person.update!(name: "Updated")
    update_event = @user.events.last
    
    assert_equal 'person.create', create_event.name
    assert_equal 'person.update', update_event.name
    assert_equal @person, create_event.resource
    assert_equal @person, update_event.resource
  end

  private

  def teardown
    # Clean up any test records
    @couple_test_class.delete_all if @couple_test_class.table_exists?
  end
end