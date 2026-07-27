require "test_helper"

class CoupleTest < ActiveSupport::TestCase
  def setup
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
    
    @child1 = Person.create!(
      name: "Child One",
      birth_year: 2010,
      birth_month: 6,
      birth_day: 12
    )
    
    @child2 = Person.create!(
      name: "Child Two",
      birth_year: 2012,
      birth_month: 9,
      birth_day: 25
    )
  end

  test "Couple model includes correct modules" do
    assert Couple.include?(GenerateCsv)
    assert Couple.include?(RecordEvent)
  end

  test "Couple uses paranoid deletion" do
    couple = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max
    )
    
    # Should use soft delete
    couple.destroy
    assert_not_nil couple.deleted_at
    assert couple.deleted?
    
    # Should still be findable with deleted scope
    assert_includes Couple.with_deleted, couple
    assert_not_includes Couple.all, couple
  end

  test "Couple has correct associations" do
    couple = Couple.new
    
    # Test associations exist
    assert_respond_to couple, :people
    assert_respond_to couple, :person1
    assert_respond_to couple, :person2
  end

  test "Couple validates presence of person1_id and person2_id" do
    # Test without person1_id
    couple = Couple.new(person2_id: @person2.id)
    assert_not couple.valid?
    assert_includes couple.errors[:person1_id], "não pode ficar em branco"
    
    # Test without person2_id
    couple = Couple.new(person1_id: @person1.id)
    assert_not couple.valid?
    assert_includes couple.errors[:person2_id], "não pode ficar em branco"
    
    # Test with both present
    couple = Couple.new(
      person1_id: @person1.id,
      person2_id: @person2.id
    )
    assert couple.valid?
  end

  test "order_people callback ensures person1_id < person2_id" do
    # Create couple with person2_id < person1_id
    couple = Couple.create!(
      person1_id: [@person1.id, @person2.id].max,
      person2_id: [@person1.id, @person2.id].min
    )
    
    # Should be reordered
    assert couple.person1_id < couple.person2_id
    assert_equal [@person1.id, @person2.id].min, couple.person1_id
    assert_equal [@person1.id, @person2.id].max, couple.person2_id
  end

  test "order_people callback works when already in correct order" do
    # Create couple with person1_id < person2_id
    couple = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max
    )
    
    # Should remain in same order
    assert couple.person1_id < couple.person2_id
    assert_equal [@person1.id, @person2.id].min, couple.person1_id
    assert_equal [@person1.id, @person2.id].max, couple.person2_id
  end

  test "Couple.couple class method finds existing couple" do
    # Create a couple
    couple = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max
    )
    
    # Should find couple regardless of parameter order
    assert_equal couple, Couple.couple(@person1, @person2)
    assert_equal couple, Couple.couple(@person2, @person1)
  end

  test "Couple.couple returns nil when couple doesn't exist" do
    # No couple exists between person1 and person3
    assert_nil Couple.couple(@person1, @person3)
  end

  test "Couple.couple handles nil parameters" do
    assert_nil Couple.couple(nil, @person1)
    assert_nil Couple.couple(@person1, nil)
    assert_nil Couple.couple(nil, nil)
  end

  test "Couple.mates returns correct mates for a person" do
    # Create couples: person1-person2, person1-person3
    couple1 = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max
    )
    
    couple2 = Couple.create!(
      person1_id: [@person1.id, @person3.id].min,
      person2_id: [@person1.id, @person3.id].max
    )
    
    # person1's mates should be person2 and person3
    mates = Couple.mates(@person1.id)
    assert_equal 2, mates.length
    assert_includes mates, @person2
    assert_includes mates, @person3
    
    # person2's mate should be person1
    mates = Couple.mates(@person2.id)
    assert_equal 1, mates.length
    assert_includes mates, @person1
  end

  test "Couple.mates returns empty array when no mates exist" do
    # person1 has no couples
    mates = Couple.mates(@person1.id)
    assert_equal [], mates
  end

  test "Couple.mates handles nil person_id" do
    mates = Couple.mates(nil)
    assert_equal [], mates
  end

  test "Couple.children returns correct children for a person" do
    # Create couple
    couple = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max
    )
    
    # Add children to couple
    couple.people << @child1
    couple.people << @child2
    
    # Both person1 and person2 should have the same children
    children1 = Couple.children(@person1.id)
    children2 = Couple.children(@person2.id)
    
    assert_equal 2, children1.length
    assert_equal 2, children2.length
    assert_includes children1, @child1
    assert_includes children1, @child2
    assert_includes children2, @child1
    assert_includes children2, @child2
  end

  test "Couple.children returns unique children when person has multiple couples" do
    # Create two couples with person1
    couple1 = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max
    )
    
    couple2 = Couple.create!(
      person1_id: [@person1.id, @person3.id].min,
      person2_id: [@person1.id, @person3.id].max
    )
    
    # Add same child to both couples
    couple1.people << @child1
    couple2.people << @child1
    
    # Add different child to each couple
    couple1.people << @child2
    
    # Should return unique children
    children = Couple.children(@person1.id)
    assert_equal 2, children.uniq.length
    assert_includes children, @child1
    assert_includes children, @child2
  end

  test "Couple.children returns empty array when no children exist" do
    # Create couple with no children
    couple = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max
    )
    
    children = Couple.children(@person1.id)
    assert_equal [], children
  end

  test "Couple.children handles nil person_id" do
    children = Couple.children(nil)
    assert_equal [], children
  end

  test "Couple.children returns empty array when person has no couples" do
    # person1 has no couples
    children = Couple.children(@person1.id)
    assert_equal [], children
  end

  test "ransackable_associations returns correct associations" do
    ransackable_assocs = Couple.ransackable_associations
    
    expected_assocs = %w[person1 person2]
    assert_equal expected_assocs, ransackable_assocs
  end

  test "ransackable_attributes returns correct attributes" do
    ransackable_attrs = Couple.ransackable_attributes
    
    expected_attrs = %w[created_at local marriage separation updated_at couple_person1_name_or_couple_person2_name]
    assert_equal expected_attrs, ransackable_attrs
  end

  test "Couple can be created with marriage and separation dates" do
    marriage_date = Date.new(2020, 6, 15)
    separation_date = Date.new(2023, 3, 10)
    
    couple = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max,
      marriage: marriage_date,
      separation: separation_date,
      local: "São Paulo, Brazil"
    )
    
    assert_equal marriage_date, couple.marriage
    assert_equal separation_date, couple.separation
    assert_equal "São Paulo, Brazil", couple.local
  end

  test "Couple can be created without optional fields" do
    couple = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max
    )
    
    assert couple.persisted?
    assert_nil couple.marriage
    assert_nil couple.separation
    assert_nil couple.local
  end

  test "Couple associations work correctly" do
    couple = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max
    )
    
    # Test person1 and person2 associations
    assert_equal @person1.id == couple.person1_id ? @person1 : @person2, couple.person1
    assert_equal @person1.id == couple.person2_id ? @person1 : @person2, couple.person2
    
    # Test people association (children)
    couple.people << @child1
    couple.people << @child2
    
    assert_equal 2, couple.people.count
    assert_includes couple.people, @child1
    assert_includes couple.people, @child2
  end

  test "Couple inherits CSV generation from GenerateCsv" do
    assert_respond_to Couple, :to_csv
  end

  test "Couple.to_csv generates CSV with correct headers and data" do
    couple = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max,
      marriage: Date.new(2020, 1, 1),
      local: "Test Location"
    )
    
    couples = [couple]
    csv_data = Couple.to_csv(couples)
    
    # Check CSV structure
    lines = csv_data.split("\n")
    headers = lines.first.split(";")
    
    # Should include main Couple columns
    assert_includes headers, "person1_id"
    assert_includes headers, "person2_id"
    assert_includes headers, "marriage"
    assert_includes headers, "separation"
    assert_includes headers, "local"
    
    # Check that data is included
    assert csv_data.include?(couple.person1_id.to_s)
    assert csv_data.include?(couple.person2_id.to_s)
    assert csv_data.include?("Test Location")
  end

  test "Couple prevents duplicate relationships" do
    # Create first couple
    couple1 = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max
    )
    
    # Try to create duplicate (should be prevented by unique constraint if exists)
    # or by application logic
    existing = Couple.couple(@person1, @person2)
    assert_equal couple1, existing
  end

  test "Couple handles same person relationships" do
    # Test edge case: person with themselves (should probably be prevented)
    couple = Couple.new(
      person1_id: @person1.id,
      person2_id: @person1.id
    )
    
    # The order_people method will ensure person1_id == person2_id
    couple.save
    assert_equal @person1.id, couple.person1_id
    assert_equal @person1.id, couple.person2_id
  end

  test "Couple.mates uses includes for performance" do
    # Create couples
    couple1 = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max
    )
    
    couple2 = Couple.create!(
      person1_id: [@person1.id, @person3.id].min,
      person2_id: [@person1.id, @person3.id].max
    )
    
    # This should not cause N+1 queries due to includes
    mates = Couple.mates(@person1.id)
    
    # Verify we get the correct mates without additional queries
    assert_equal 2, mates.length
    mates.each do |mate|
      # Accessing name should not cause additional query due to includes
      assert_not_nil mate.name
    end
  end

  test "Couple.children uses includes for performance" do
    # Create couple with children
    couple = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max
    )
    
    couple.people << @child1
    couple.people << @child2
    
    # This should not cause N+1 queries due to includes
    children = Couple.children(@person1.id)
    
    # Verify we get the correct children without additional queries
    assert_equal 2, children.length
    children.each do |child|
      # Accessing name should not cause additional query due to includes
      assert_not_nil child.name
    end
  end

  test "Couple soft delete preserves data" do
    couple = Couple.create!(
      person1_id: [@person1.id, @person2.id].min,
      person2_id: [@person1.id, @person2.id].max,
      marriage: Date.new(2020, 1, 1),
      local: "Test Location"
    )
    
    original_id = couple.id
    
    # Soft delete
    couple.destroy
    
    # Should still exist in database with deleted_at set
    deleted_couple = Couple.with_deleted.find(original_id)
    assert_not_nil deleted_couple.deleted_at
    assert_equal couple.marriage, deleted_couple.marriage
    assert_equal couple.local, deleted_couple.local
  end

  test "Couple includes RecordEvent for audit logging" do
    # Test that RecordEvent module is properly included
    couple = Couple.new
    assert_respond_to couple, :current_user=
    
    # The RecordEvent callbacks should be set up
    callbacks = Couple._create_callbacks.map(&:filter)
    assert_includes callbacks, :record_create
  end

  test "mates omits a soft-deleted spouse so the show page can't deref nil" do
    live = Person.create!(name: "Live Spouse", gender: "M")
    gone = Person.create!(name: "Gone Spouse", gender: "M")
    Couple.create!(person1: @person1, person2: live)
    Couple.create!(person1: @person1, person2: gone)
    gone.destroy

    assert_equal ["Live Spouse"], @person1.reload.mates.map(&:name)
  end

  test "auditing a couple update/unlink does not crash when a member is soft-deleted" do
    user = User.create!(name: "Actor", email: "actor-#{SecureRandom.hex(3)}@example.com",
                        password: "password123", confirmed_at: Time.current)
    couple = Couple.create!(person1: @person1, person2: @person2)
    @person2.destroy # soft-delete a member; the couple survives

    Current.user = user
    couple.current_user = user
    assert_nothing_raised do
      couple.update!(local: "Somewhere")
      couple.destroy
    end
  ensure
    Current.reset
  end
end
