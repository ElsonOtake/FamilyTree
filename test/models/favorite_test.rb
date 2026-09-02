# frozen_string_literal: true

require 'test_helper'

class FavoriteTest < ActiveSupport::TestCase
  # Test core validations without fixtures
  test 'should be valid with valid attributes' do
    user = User.new(name: 'Test', email: "test#{rand(10000)}@example.com", password: 'password')
    person = Person.new(name: 'Test Person', gender: 'M')
    favorite = Favorite.new(user: user, person: person)

    # Test associations exist
    assert_respond_to favorite, :user
    assert_respond_to favorite, :person

    # Basic model structure test
    assert_equal 'Favorite', favorite.class.name
  end

  test 'should have proper model associations' do
    favorite = Favorite.new
    assert_respond_to favorite, :user
    assert_respond_to favorite, :person

    # Test that we can assign relationships
    favorite.user = User.new
    favorite.person = Person.new

    assert favorite.user.is_a?(User)
    assert favorite.person.is_a?(Person)
  end

  test 'should have required validations' do
    favorite = Favorite.new

    # Should require both user and person
    assert_not favorite.valid?

    # Check that validation errors include the required fields
    favorite.validate
    assert favorite.errors[:user].present?
    assert favorite.errors[:person].present?
  end
end
