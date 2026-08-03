require "test_helper"

class PersonTest < ActiveSupport::TestCase
  def setup
    @person = Person.new(
      name: "Test Person",
      birth_year: 1990,
      birth_month: 9,
      birth_day: 20
    )
  end

  test "days_until_birthday returns correct positive value for future birthday" do
    travel_to Date.new(2025, 9, 15) do # 5 days before birthday
      assert_equal 5, @person.days_until_birthday
    end
  end

  test "days_until_birthday returns correct negative value for past birthday" do
    travel_to Date.new(2025, 9, 25) do # 5 days after birthday
      assert_equal -5, @person.days_until_birthday
    end
  end

  test "days_until_birthday returns zero for birthday today" do
    travel_to Date.new(2025, 9, 20) do # On birthday
      assert_equal 0, @person.days_until_birthday
    end
  end

  test "birthday_this_year returns correct date in São Paulo timezone" do
    travel_to Time.zone.parse("2025-09-20 12:00:00") do
      expected_birthday = Date.new(2025, 9, 20)
      assert_equal expected_birthday, @person.birthday_this_year
    end
  end

  test "upcoming_birthdays includes people with birthdays in range" do
    # Create people with birthdays around current date
    person_past = Person.create!(
      name: "Past Birthday", 
      birth_year: 1985, 
      birth_month: 9, 
      birth_day: 15
    )
    person_future = Person.create!(
      name: "Future Birthday",
      birth_year: 1995,
      birth_month: 9,
      birth_day: 25
    )
    person_today = Person.create!(
      name: "Today Birthday",
      birth_year: 2000,
      birth_month: 9,
      birth_day: 20
    )

    travel_to Date.new(2025, 9, 20) do
      upcoming = Person.upcoming_birthdays(7, 7)
      
      assert_includes upcoming, person_past
      assert_includes upcoming, person_future  
      assert_includes upcoming, person_today
    end
  end

  test "upcoming_birthdays_for_people returns correct results" do
    # Create people with birthdays around current date
    person_past = Person.create!(
      name: "Past Birthday", 
      birth_year: 1985, 
      birth_month: 9, 
      birth_day: 15
    )
    person_future = Person.create!(
      name: "Future Birthday",
      birth_year: 1995,
      birth_month: 9,
      birth_day: 25
    )
    person_today = Person.create!(
      name: "Today Birthday",
      birth_year: 2000,
      birth_month: 9,
      birth_day: 20
    )
    person_excluded = Person.create!(
      name: "Excluded Person",
      birth_year: 1990,
      birth_month: 9,
      birth_day: 22
    )

    # Create a collection that includes only some people
    favorites_collection = Person.where(id: [person_past.id, person_future.id, person_today.id])

    travel_to Date.new(2025, 9, 20) do
      upcoming = Person.upcoming_birthdays_for_people(favorites_collection, 7, 7)
      
      # Should include people from the collection
      assert_includes upcoming, person_past
      assert_includes upcoming, person_future  
      assert_includes upcoming, person_today
      
      # Should NOT include people outside the collection
      assert_not_includes upcoming, person_excluded
    end
  end

  test "upcoming_birthdays handles month boundaries correctly" do
    # Person with birthday at end of previous month
    person_prev_month = Person.create!(
      name: "Previous Month Birthday",
      birth_year: 1990,
      birth_month: 8,
      birth_day: 28
    )
    
    # Person with birthday at start of next month
    person_next_month = Person.create!(
      name: "Next Month Birthday", 
      birth_year: 1990,
      birth_month: 10,
      birth_day: 5
    )

    # Test from September 1 - should include both
    travel_to Date.new(2025, 9, 1) do
      upcoming = Person.upcoming_birthdays(7, 7)
      
      # August 28 is 4 days ago, should be included
      assert_includes upcoming, person_prev_month
      # October 5 is 34 days in the future, should NOT be included
      assert_not_includes upcoming, person_next_month
    end
    
    # Test from September 30 - should include October birthday
    travel_to Date.new(2025, 9, 30) do
      upcoming = Person.upcoming_birthdays(7, 7)
      
      # October 5 is 5 days in the future, should be included
      assert_includes upcoming, person_next_month
    end
  end

  test "age_on_birthday only returns age for living people" do
    living_person = Person.new(
      name: "Living Person",
      birth_year: 1990,
      birth_month: 9, 
      birth_day: 20
    )
    
    deceased_person = Person.new(
      name: "Deceased Person",
      birth_year: 1950,
      birth_month: 9,
      birth_day: 20,
      death_year: 2020
    )

    travel_to Date.new(2025, 9, 20) do
      assert_equal 35, living_person.age_on_birthday
      assert_nil deceased_person.age_on_birthday
    end
  end

  test "alive? method correctly identifies living vs deceased people" do
    living_person = Person.new(name: "Living", death_year: nil)
    deceased_person = Person.new(name: "Deceased", death_year: 2020)
    
    assert living_person.alive?
    assert_not deceased_person.alive?
  end

  test "alive? respects the alive flag when no death year is recorded" do
    flagged_deceased = Person.new(name: "Flagged", alive: false, death_year: nil)
    unknown_status = Person.new(name: "Unknown", alive: nil, death_year: nil)

    assert_not flagged_deceased.alive?
    assert unknown_status.alive?, "nil flag means unknown, treated as alive"
  end

  test "birthday calculations work across timezone changes" do
    # Test that birthday calculations remain consistent
    # even when timezone is configured differently
    original_timezone = Time.zone
    
    begin
      Time.zone = "UTC"
      utc_birthday = @person.birthday_this_year
      utc_days_until = @person.days_until_birthday
      
      Time.zone = "America/Sao_Paulo" 
      sao_paulo_birthday = @person.birthday_this_year
      sao_paulo_days_until = @person.days_until_birthday
      
      # Birthday dates should be the same regardless of timezone
      assert_equal utc_birthday, sao_paulo_birthday
      assert_equal utc_days_until, sao_paulo_days_until
    ensure
      Time.zone = original_timezone
    end
  end

  test "partial dates handle missing components correctly" do
    # Person with only year and month
    person_partial = Person.new(
      name: "Partial Date",
      birth_year: 1990,
      birth_month: 9,
      birth_day: nil
    )
    
    assert_nil person_partial.days_until_birthday
    assert_nil person_partial.birthday_this_year
    assert_nil person_partial.age_on_birthday
  end

  test "invalid dates are handled gracefully" do
    # Person with invalid date (Feb 30)
    person_invalid = Person.new(
      name: "Invalid Date",
      birth_year: 1990,
      birth_month: 2,
      birth_day: 30
    )

    assert_nil person_invalid.birthday_this_year
    assert_nil person_invalid.days_until_birthday
  end

  # GENDER RANSACK TESTS
  test "ransack matches gender by enum key, not a coerced integer" do
    female = Person.create!(name: "Fem", gender: "F")
    male = Person.create!(name: "Male", gender: "M")

    result_ids = Person.ransack(gender_eq: "F").result.ids
    assert_includes result_ids, female.id
    assert_not_includes result_ids, male.id, "gender_eq 'F' must not coerce to 0 (Male)"

    # The main app filters via gender_in with integers; that must still work.
    int_ids = Person.ransack(gender_in: [Person.genders["F"]]).result.ids
    assert_includes int_ids, female.id
    assert_not_includes int_ids, male.id
  end

  # AUDIT EVENT TESTS
  test "person update is audited via Current.user, silent without an actor" do
    user = User.new(name: "Actor", email: "actor-#{SecureRandom.hex(3)}@example.com",
                    password: "password123", confirmed_at: Time.current)
    user.save!
    person = Person.create!(name: "Before", gender: "M")

    assert_no_difference -> { Event.where(name: "person.update").count } do
      person.update!(name: "NoActor") # no current_user and no Current.user set
    end

    Current.user = user
    assert_difference -> { Event.where(name: "person.update").count }, 1 do
      person.update!(name: "WithActor")
    end
    assert_equal user, Event.where(name: "person.update").order(:id).last.user
  ensure
    Current.user = nil
  end

  # PARENT LOOKUP TESTS
  test "father and mother return the male and female parent" do
    child = build_child_of("Dad", "M", "Mom", "F")

    assert_equal "Dad", child.father.name
    assert_equal "Mom", child.mother.name
  end

  test "father and mother order parents by gender regardless of couple order" do
    # person1 is female, person2 is male: father must still be the male parent.
    child = build_child_of("Mom", "F", "Dad", "M")

    assert_equal "Dad", child.father.name
    assert_equal "Mom", child.mother.name
  end

  test "soft-deleting a parent does not break father/mother (regression)" do
    child = build_child_of("Dad", "M", "Mom", "F")
    child.father.destroy # soft delete the father

    child.reload
    assert_nil child.father, "deleted father should drop out"
    assert_equal "Mom", child.mother.name, "surviving parent should still show, once"
  end

  test "cousins is nil-safe when a parent is soft-deleted (regression)" do
    child = build_child_of("Dad", "M", "Mom", "F")
    child.mother.destroy

    child.reload
    assert_nothing_raised { child.cousins }
  end

  # BIRTH-ORDER TESTS (children & siblings, matching the tree PDFs)
  test "children are ordered oldest first by birth date" do
    user = User.create!(name: "Rec", email: "rec-#{SecureRandom.hex(4)}@example.com",
                        password: "password123", confirmed_at: Time.current)
    dad = Person.create!(name: "Dad", gender: "M")
    mom = Person.create!(name: "Mom", gender: "F")
    couple = Couple.create!(person1: dad, person2: mom)
    young = Person.create!(name: "Young", gender: "X", birth: Date.new(2010, 1, 1))
    old = Person.create!(name: "Old", gender: "X", birth: Date.new(2000, 1, 1))
    mid = Person.create!(name: "Mid", gender: "X", birth_year: 2005)
    [young, old, mid].each { |p| Child.create!(couple: couple, person: p, current_user: user) }

    assert_equal %w[Old Mid Young], dad.children.map(&:name)
  end

  test "siblings are ordered oldest first and exclude self" do
    user = User.create!(name: "Rec", email: "rec-#{SecureRandom.hex(4)}@example.com",
                        password: "password123", confirmed_at: Time.current)
    couple = Couple.create!(person1: Person.create!(name: "F", gender: "M"),
                            person2: Person.create!(name: "M", gender: "F"))
    young = Person.create!(name: "Young", gender: "X", birth: Date.new(2010, 1, 1))
    old = Person.create!(name: "Old", gender: "X", birth: Date.new(2000, 1, 1))
    mid = Person.create!(name: "Mid", gender: "X", birth_year: 2005)
    [young, old, mid].each { |p| Child.create!(couple: couple, person: p, current_user: user) }

    assert_equal %w[Old Young], mid.siblings.map(&:name)
  end

  private

  def build_child_of(p1_name, p1_gender, p2_name, p2_gender)
    user = User.create!(name: "Recorder", email: "rec-#{SecureRandom.hex(4)}@example.com",
                        password: "password123", confirmed_at: Time.current)
    p1 = Person.create!(name: p1_name, gender: p1_gender)
    p2 = Person.create!(name: p2_name, gender: p2_gender)
    couple = Couple.create!(person1: p1, person2: p2)
    child = Person.create!(name: "Kid", gender: "X")
    Child.create!(couple: couple, person: child, current_user: user)
    child
  end
end
