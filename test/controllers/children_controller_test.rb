require "test_helper"

class ChildrenControllerTest < ActionDispatch::IntegrationTest
  def setup
    # Create roles if they don't exist
    Role.find_or_create_by(name: 'admin')
    Role.find_or_create_by(name: 'gold')
    Role.find_or_create_by(name: 'silver')
    Role.find_or_create_by(name: 'bronze')
    
    @user = users(:one)
    @user.add_role(:admin)  # Use admin role for full access
    
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
    
    @another_child = Person.create!(
      name: "Another Child",
      birth_year: 2012,
      birth_month: 7,
      birth_day: 5
    )
    
    # Create a couple
    @couple = Couple.create!(
      person1_id: [@parent1.id, @parent2.id].min,
      person2_id: [@parent1.id, @parent2.id].max
    )
    
    sign_in_as(@user)
  end

  test "should get new" do
    get new_person_couple_child_path(@parent1, @couple)
    assert_response :success
  end

  test "new action sets session id" do
    get new_person_couple_child_path(@parent1, @couple)
    assert_equal @parent1.id, session[:id]
  end

  test "should create child successfully" do
    assert_difference('Event.count', 1) do
      post person_couple_children_path(@parent1, @couple), params: { 
        child_id: @child.id 
      }
    end
    
    assert_redirected_to person_path(@parent1)
    
    # Verify child was added to couple
    @couple.reload
    assert_includes @couple.people, @child
    
    # Verify event was created
    event = Event.last
    assert_equal 'child.create', event.name
    assert_equal @child, event.resource
    assert_equal @user, event.user
    assert_equal @couple.id, event.data['couple_id']
  end

  test "should handle create with turbo stream" do
    post person_couple_children_path(@parent1, @couple), 
         params: { child_id: @child.id }, 
         headers: { "Accept" => "text/vnd.turbo-stream.html" }
    
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    
    # Verify child was added
    @couple.reload
    assert_includes @couple.people, @child
  end

  test "should handle adding child multiple times" do
    # Add a child that's already added - this should fail due to uniqueness validation
    Child.create!(person_id: @child.id, couple_id: @couple.id)

    # Try to add the same child again - should fail validation
    assert_no_difference('Child.count') do
      post person_couple_children_path(@parent1, @couple), params: {
        child_id: @child.id
      }, headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end

    assert_response :success
  end

  test "should destroy child relationship" do
    # First add child to couple
    @couple.people << @child
    
    assert_difference('Event.count', 1) do
      delete person_couple_child_path(@parent1, @couple, @child)
    end
    
    assert_redirected_to person_path(@parent1)
    
    # Verify child was removed from couple
    @couple.reload
    assert_not_includes @couple.people, @child
    
    # Verify event was created
    event = Event.last
    assert_equal 'child.unlink', event.name
    assert_equal @child, event.resource
    assert_equal @user, event.user
    assert_equal @couple.id, event.data['couple_id']
  end

  test "should handle destroy with turbo stream" do
    @couple.people << @child
    
    delete person_couple_child_path(@parent1, @couple, @child), 
           headers: { "Accept" => "text/vnd.turbo-stream.html" }
    
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    
    # Verify child was removed
    @couple.reload
    assert_not_includes @couple.people, @child
  end

  test "should download children CSV" do
    # Add some children to couples for CSV export
    @couple.people << @child
    @couple.people << @another_child
    
    get download_children_path(format: :csv)
    
    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_includes response.headers['Content-Disposition'], 'children'
    assert_includes response.headers['Content-Disposition'], Date.today.to_s
    
    # Verify CSV contains data
    csv_data = response.body
    assert_includes csv_data, @child.id.to_s
    assert_includes csv_data, @couple.id.to_s
  end

  test "should require authentication" do
    sign_out
    
    get new_person_couple_child_path(@parent1, @couple)
    assert_redirected_to new_user_session_path
    
    post person_couple_children_path(@parent1, @couple), params: { 
      child_id: @child.id 
    }
    assert_redirected_to new_user_session_path
    
    delete person_couple_child_path(@parent1, @couple, @child)
    assert_redirected_to new_user_session_path
  end

  test "should handle authorization" do
    # Test with a user who doesn't have proper authorization
    sign_out
    unauthorized_user = User.create!(
      name: "Unauthorized User",
      email: "unauthorized@example.com", 
      password: "password",
      confirmed_at: 1.week.ago
    )
    unauthorized_user.add_role(:bronze) # Bronze role doesn't have access to child operations
    
    sign_in_as(unauthorized_user)
    
    get new_person_couple_child_path(@parent1, @couple)
    assert_response :redirect # Should redirect due to authorization failure
  end

  test "should handle missing person" do
    get new_person_couple_child_path(99999, @couple)
    assert_response :not_found
  end

  test "should handle missing couple" do
    get new_person_couple_child_path(@parent1, 99999)
    assert_response :not_found
  end

  test "should handle missing child in create" do
    post person_couple_children_path(@parent1, @couple), params: {
      child_id: 99999
    }
    assert_response :not_found
  end

  test "should handle missing child in destroy" do
    delete person_couple_child_path(@parent1, @couple, 99999)
    # Person with ID 99999 doesn't exist, so expect 404
    assert_response :not_found
  end

  test "should handle destroy when relationship doesn't exist" do
    # Try to delete a child that exists but isn't linked to this couple
    delete person_couple_child_path(@parent1, @couple, @child)

    assert_redirected_to person_path(@parent1)
    assert_equal I18n.t('children.errors.relationship_not_found'), flash[:alert]
  end

  test "should handle destroy when relationship doesn't exist with turbo stream" do
    # Try to delete a child that exists but isn't linked to this couple
    delete person_couple_child_path(@parent1, @couple, @child),
           headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    # Should render flash message about relationship not found
    assert_includes response.body, I18n.t('children.errors.relationship_not_found')
  end

  test "Child model methods work correctly" do
    # Test Child model methods used in controller
    @couple.people << @child
    
    children = Child.all
    assert_includes children.pluck(:person_id), @child.id
    assert_includes children.pluck(:couple_id), @couple.id
    
    # Test column_names method
    assert_includes Child.column_names, 'person_id'
    assert_includes Child.column_names, 'couple_id'
  end

  test "Child model creates event automatically on save" do
    child_model = Child.new(person_id: @child.id, couple_id: @couple.id)
    child_model.current_user = @user

    assert_difference('Event.count', 1) do
      child_model.save!
    end

    event = Event.last
    assert_equal 'child.create', event.name
    assert_equal @child, event.resource
    assert_equal @user, event.user
    assert_equal @couple.id, event.data['couple_id']
  end

  test "re-adding a previously unlinked child restores the soft-deleted link" do
    Child.create!(couple: @couple, person: @child, current_user: @user)
    Child.find_by(person_id: @child.id, couple_id: @couple.id).destroy
    assert_not_includes @couple.reload.people, @child

    # Composite PK allows one row per pair; re-adding must restore, not insert.
    assert_nothing_raised do
      post person_couple_children_path(@parent1, @couple), params: { child_id: @child.id }
    end

    assert_redirected_to person_path(@parent1)
    assert_includes @couple.reload.people, @child
    assert_equal 1, Child.with_deleted.where(person_id: @child.id, couple_id: @couple.id).count
  end

  private

  def sign_in_as(user)
    post user_session_path, params: { 
      user: { 
        email: user.email, 
        password: 'password' 
      } 
    }
  end

  def sign_out
    delete destroy_user_session_path
  end

end
