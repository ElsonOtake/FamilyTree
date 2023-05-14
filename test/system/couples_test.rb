require "application_system_test_case"

class CouplesTest < ApplicationSystemTestCase
  setup do
    @couple = couples(:one)
  end

  test "visiting the index" do
    visit couples_url
    assert_selector "h1", text: "Couples"
  end

  test "should create couple" do
    visit couples_url
    click_on "New couple"

    fill_in "Local", with: @couple.local
    fill_in "Marriage", with: @couple.marriage
    fill_in "Separation", with: @couple.separation
    fill_in "Person1", with: @couple.person1_id
    fill_in "Person2", with: @couple.person2_id
    click_on "Create Couple"

    assert_text "Couple was successfully created"
    click_on "Back"
  end

  test "should update Couple" do
    visit couple_url(@couple)
    click_on "Edit this couple", match: :first

    fill_in "Local", with: @couple.local
    fill_in "Marriage", with: @couple.marriage
    fill_in "Separation", with: @couple.separation
    fill_in "Person1", with: @couple.person1_id
    fill_in "Person2", with: @couple.person2_id
    click_on "Update Couple"

    assert_text "Couple was successfully updated"
    click_on "Back"
  end

  test "should destroy Couple" do
    visit couple_url(@couple)
    click_on "Destroy this couple", match: :first

    assert_text "Couple was successfully destroyed"
  end
end
