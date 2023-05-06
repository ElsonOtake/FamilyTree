require "application_system_test_case"

class TreesTest < ApplicationSystemTestCase
  setup do
    @tree = trees(:one)
  end

  test "visiting the index" do
    visit trees_url
    assert_selector "h1", text: "Trees"
  end

  test "should create tree" do
    visit trees_url
    click_on "New tree"

    check "Alive" if @tree.alive
    fill_in "Birth", with: @tree.birth
    fill_in "Death", with: @tree.death
    fill_in "Name", with: @tree.name
    fill_in "description", with: @tree.description
    check "gender" if @tree.gender
    click_on "Create Tree"

    assert_text "Tree was successfully created"
    click_on "Back"
  end

  test "should update Tree" do
    visit tree_url(@tree)
    click_on "Edit this tree", match: :first

    check "Alive" if @tree.alive
    fill_in "Birth", with: @tree.birth
    fill_in "Death", with: @tree.death
    fill_in "Name", with: @tree.name
    fill_in "description", with: @tree.description
    check "gender" if @tree.gender
    click_on "Update Tree"

    assert_text "Tree was successfully updated"
    click_on "Back"
  end

  test "should destroy Tree" do
    visit tree_url(@tree)
    click_on "Destroy this tree", match: :first

    assert_text "Tree was successfully destroyed"
  end
end
