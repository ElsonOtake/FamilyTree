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
end
