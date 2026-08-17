require "test_helper"

# Exercises the RecordEvent concern against the two models that include it:
# Person (one event per write, resource = self) and Couple (two events per write,
# one per partner). The acting user is current_user, falling back to Current.user.
class RecordEventTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @person = people(:one)
    @person2 = people(:two)
    Current.user = nil # avoid the request-wide fallback leaking between tests
  end

  def teardown
    Current.user = nil
  end

  # A brand-new (unsaved) Person, since record_create only fires on create.
  def build_person(attrs = {})
    Person.new({ name: "Fresh Person", birth_year: 1990 }.merge(attrs))
  end

  # INITIALIZATION
  test "adds a current_user accessor" do
    assert_respond_to Couple.new, :current_user
    assert_respond_to Couple.new, :current_user=
  end

  test "registers the create/update/destroy callbacks" do
    assert_includes Couple._create_callbacks.map(&:filter), :record_create
    assert_includes Couple._update_callbacks.map(&:filter), :record_update
    assert_includes Couple._destroy_callbacks.map(&:filter), :record_destroy
  end

  # PERSON — CREATE
  test "record_create logs a person.create event when current_user is set" do
    person = build_person
    person.current_user = @user

    assert_difference "@user.events.count", 1 do
      person.save!
    end

    event = @user.events.last
    assert_equal "person.create", event.name
    assert_equal person, event.resource
    assert_not_nil event.data
  end

  test "record_create logs nothing when there is no actor" do
    assert_no_difference "Event.count" do
      Person.create!(name: "No Actor", birth_year: 1990)
    end
  end

  test "record_create falls back to Current.user" do
    Current.user = @user
    assert_difference "@user.events.count", 1 do
      Person.create!(name: "Via Current", birth_year: 1990)
    end
  end

  test "record_create data holds final values and filters id/updated_at/blank" do
    person = build_person(name: "Named", kanji: nil)
    person.current_user = @user
    person.save!

    data = @user.events.last.data
    assert_equal "Named", data["name"] # final value, not a [old, new] pair
    assert_not_includes data.keys, "id"
    assert_not_includes data.keys, "updated_at"
    assert_not_includes data.keys, "kanji" # nil values are dropped
  end

  # PERSON — UPDATE
  test "record_update logs a person.update event with change arrays" do
    @person.current_user = @user
    old_name = @person.name

    assert_difference "@user.events.count", 1 do
      @person.update!(name: "Renamed")
    end

    event = @user.events.last
    assert_equal "person.update", event.name
    assert_equal [old_name, "Renamed"], event.data["name"]
  end

  test "record_update logs nothing when there is no actor" do
    @person.current_user = nil
    assert_no_difference "Event.count" do
      @person.update!(name: "Silent Rename")
    end
  end

  # COUPLE (non-Person) — one event per partner
  test "record_create logs a couple.create event for each partner" do
    couple = Couple.new(person1_id: @person.id, person2_id: @person2.id, marriage: Date.current)
    couple.current_user = @user

    assert_difference "@user.events.count", 2 do
      couple.save!
    end

    events = @user.events.last(2)
    assert events.all? { |e| e.name == "couple.create" }
    assert_equal [@person, @person2].to_set, events.map(&:resource).to_set
  end

  test "record_update logs a couple.update event for each partner" do
    couple = Couple.create!(person1_id: @person.id, person2_id: @person2.id, marriage: Date.current)
    couple.current_user = @user

    assert_difference "@user.events.count", 2 do
      couple.update!(marriage: Date.yesterday)
    end

    events = @user.events.last(2)
    assert events.all? { |e| e.name == "couple.update" }
    assert_equal [@person, @person2].to_set, events.map(&:resource).to_set
  end

  test "record_destroy logs a couple.unlink event for each partner on soft delete" do
    couple = Couple.create!(person1_id: @person.id, person2_id: @person2.id, marriage: Date.current)
    couple.current_user = @user

    assert_difference "@user.events.count", 2 do
      couple.destroy # paranoia soft delete
    end

    events = @user.events.last(2)
    assert events.all? { |e| e.name == "couple.unlink" }
    assert events.all? { |e| e.data["deleted_at"].present? }
    assert_equal [@person, @person2].to_set, events.map(&:resource).to_set
  end

  test "record_destroy logs nothing when there is no actor" do
    couple = Couple.create!(person1_id: @person.id, person2_id: @person2.id, marriage: Date.current)
    couple.current_user = nil
    assert_no_difference "Event.count" do
      couple.destroy
    end
  end

  test "record_destroy only fires on logical (soft) deletion" do
    couple = Couple.create!(person1_id: @person.id, person2_id: @person2.id, marriage: Date.current)
    couple.current_user = @user
    couple.define_singleton_method(:destroyed_logically?) { false }

    assert_no_difference "@user.events.count" do
      couple.destroy
    end
  end

  # destroyed_logically?
  test "destroyed_logically? tracks deleted_at" do
    couple = Couple.new
    couple.deleted_at = Time.current
    assert couple.send(:destroyed_logically?)
    couple.deleted_at = nil
    assert_not couple.send(:destroyed_logically?)
  end

  # GRACEFUL HANDLING
  test "a couple missing a partner is invalid and logs nothing" do
    couple = Couple.new(person2_id: @person2.id) # no person1_id
    couple.current_user = @user
    assert_no_difference "Event.count" do
      assert_not couple.save
    end
  end

  # EVENT NAMING / CLASS IDENTIFICATION
  test "event names use the class name underscored" do
    person = build_person
    person.current_user = @user
    person.save!
    assert_equal "person.create", @user.events.last.name

    couple = Couple.new(person1_id: @person.id, person2_id: @person2.id, marriage: Date.current)
    couple.current_user = @user
    couple.save!
    assert_equal "couple.create", @user.events.last.name
  end

  test "handles multiple operations on the same record" do
    person = build_person
    person.current_user = @user
    person.save!
    assert_equal "person.create", @user.events.last.name

    person.update!(name: "Second Name")
    assert_equal "person.update", @user.events.last.name
  end
end
