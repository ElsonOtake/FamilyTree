require "test_helper"
require "ostruct"

# Configure ActionMailer for tests
ActionMailer::Base.default_url_options[:host] = "test.host"

class UserTest < ActiveSupport::TestCase
  def setup
    @valid_attributes = {
      name: "Test User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    }
  end

  # BASIC MODEL TESTS
  test "User model includes correct modules" do
    assert User.include?(ActiveModel::Dirty)
  end

  test "User has correct associations" do
    user = User.new
    
    # Test associations exist
    assert_respond_to user, :events
    assert_respond_to user, :favorites
    assert_respond_to user, :favorite_people
    assert_respond_to user, :roles
  end

  test "User uses rolify" do
    user = User.new
    
    # Test rolify methods are available
    assert_respond_to user, :add_role
    assert_respond_to user, :has_role?
    assert_respond_to user, :remove_role
  end

  # VALIDATION TESTS
  test "should be valid with valid attributes" do
    user = User.new(@valid_attributes)
    assert user.valid?
  end

  test "should require name" do
    user = User.new(@valid_attributes.except(:name))
    assert_not user.valid?
    assert_includes user.errors[:name], "não pode ficar em branco"
  end

  test "should require email" do
    user = User.new(@valid_attributes.except(:email))
    assert_not user.valid?
    assert_includes user.errors[:email], "não pode ficar em branco"
  end

  test "should require password for new users" do
    user = User.new(@valid_attributes.except(:password))
    assert_not user.valid?
    assert_includes user.errors[:password], "não pode ficar em branco"
  end

  test "should validate email format" do
    invalid_emails = ["invalid", "invalid@", "@example.com", "invalid.email"]
    
    invalid_emails.each do |email|
      user = User.new(@valid_attributes.merge(email: email))
      assert_not user.valid?, "#{email} should be invalid"
      assert_includes user.errors[:email], "não é válido"
    end
  end

  test "should validate email uniqueness" do
    User.create!(@valid_attributes)
    
    duplicate_user = User.new(@valid_attributes.merge(name: "Different Name"))
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "já está em uso"
  end

  test "should validate password length" do
    short_password = "12345"
    user = User.new(@valid_attributes.merge(password: short_password, password_confirmation: short_password))
    assert_not user.valid?
    assert_includes user.errors[:password], "é muito curto (mínimo: 6 caracteres)"
  end

  # TREE SETTINGS TESTS
  test "new user defaults to 5 generations with pets excluded" do
    user = User.new(@valid_attributes)
    assert_equal 5, user.tree_generations
    assert_equal false, user.include_pets_in_tree
  end

  test "tree_generations must be an integer within 1..10" do
    user = User.new(@valid_attributes)

    [0, 11, 2.5, nil].each do |value|
      user.tree_generations = value
      assert_not user.valid?, "#{value.inspect} should be invalid"
      assert user.errors[:tree_generations].any?
    end

    [1, 5, 10].each do |value|
      user.tree_generations = value
      assert user.valid?, "#{value} should be valid"
    end
  end

  # LOCALE ENUM TESTS
  test "should have locale enum" do
    user = User.new(@valid_attributes)
    
    # Test enum values
    assert_respond_to user, :locale
    assert_respond_to user, :pt?
    assert_respond_to user, :en?
    assert_respond_to user, :ja?
  end

  test "should set and get locale enum values" do
    user = User.create!(@valid_attributes)
    
    # Test setting locale values
    user.pt!
    assert user.pt?
    assert_equal "pt", user.locale
    
    user.en!
    assert user.en?
    assert_equal "en", user.locale
    
    user.ja!
    assert user.ja?
    assert_equal "ja", user.locale
  end

  test "should handle invalid locale values" do
    user = User.new(@valid_attributes)
    
    assert_raises(ArgumentError) do
      user.locale = "invalid_locale"
    end
  end

  # CALLBACK TESTS
  test "should downcase email before save" do
    user = User.create!(@valid_attributes.merge(email: "TEST@EXAMPLE.COM"))
    assert_equal "test@example.com", user.email
  end

  test "should assign default role after create" do
    user = User.create!(@valid_attributes)
    assert user.has_role?(:bronze)
    assert_equal 1, user.roles.count
  end

  test "should not assign default role if user already has roles" do
    user = User.create!(@valid_attributes)
    user.add_role(:admin)
    
    # Remove bronze role to test
    user.remove_role(:bronze)
    assert_not user.has_role?(:bronze)
    assert user.has_role?(:admin)
    
    # Save again to trigger callback
    user.save!
    
    # Should not add bronze role since user has admin role
    assert_not user.has_role?(:bronze)
    assert user.has_role?(:admin)
  end

  # DEVISE FUNCTIONALITY TESTS
  test "should have devise modules configured" do
    devise_modules = User.devise_modules
    
    expected_modules = [
      :database_authenticatable, :registerable, :confirmable,
      :recoverable, :rememberable, :validatable, :trackable, :omniauthable
    ]
    
    expected_modules.each do |mod|
      assert_includes devise_modules, mod, "Should include #{mod} devise module"
    end
  end

  test "should have omniauth providers configured" do
    assert_includes User.omniauth_providers, :google_oauth2
  end

  test "should track sign in information" do
    user = User.create!(@valid_attributes)
    
    # Should have trackable fields
    assert_respond_to user, :sign_in_count
    assert_respond_to user, :current_sign_in_at
    assert_respond_to user, :last_sign_in_at
    assert_respond_to user, :current_sign_in_ip
    assert_respond_to user, :last_sign_in_ip
  end

  # OMNIAUTH TESTS
  test "omniauth_login? should return true when provider is present" do
    user = User.new(@valid_attributes.merge(provider: "google_oauth2"))
    assert user.omniauth_login?
  end

  test "omniauth_login? should return false when provider is nil" do
    user = User.new(@valid_attributes)
    assert_not user.omniauth_login?
  end

  test "from_omniauth should find existing user by email" do
    existing_user = User.create!(@valid_attributes)
    
    # Mock access token
    access_token = OpenStruct.new(
      info: OpenStruct.new(
        email: existing_user.email,
        name: "OAuth Name"
      ),
      provider: "google_oauth2"
    )
    
    found_user = User.from_omniauth(access_token)
    assert_equal existing_user, found_user
  end

  test "from_omniauth should create new user when email not found" do
    # Mock access token for new user
    access_token = OpenStruct.new(
      info: OpenStruct.new(
        email: "newuser@example.com",
        name: "New OAuth User"
      ),
      provider: "google_oauth2"
    )
    
    assert_difference('User.count', 1) do
      user = User.from_omniauth(access_token)
      assert user.persisted?
      assert_equal "newuser@example.com", user.email
      assert_equal "New OAuth User", user.name
      assert_equal "google_oauth2", user.provider
      assert_not_nil user.confirmed_at
    end
  end

  test "from_omniauth creates user with generated password" do
    access_token = OpenStruct.new(
      info: OpenStruct.new(
        email: "oauth@example.com",
        name: "OAuth User"
      ),
      provider: "google_oauth2"
    )
    
    user = User.from_omniauth(access_token)
    assert user.persisted?
    # Password should be generated and encrypted
    assert_not_nil user.encrypted_password
  end

  # ROLE TESTS
  test "should work with role system" do
    user = User.create!(@valid_attributes)
    
    # Should have default bronze role
    assert user.has_role?(:bronze)
    
    # Should be able to add other roles
    user.add_role(:admin)
    assert user.has_role?(:admin)
    assert user.has_role?(:bronze)
    
    # Should be able to remove roles
    user.remove_role(:bronze)
    assert_not user.has_role?(:bronze)
    assert user.has_role?(:admin)
  end

  test "should support role hierarchy" do
    user = User.create!(@valid_attributes)
    
    # Test different role levels
    standard_roles = [:bronze, :silver, :gold, :admin]
    
    standard_roles.each do |role|
      user.remove_role(:bronze) if user.has_role?(:bronze)
      user.add_role(role)
      assert user.has_role?(role), "Should have #{role} role"
    end
  end

  # ASSOCIATION TESTS
  test "should have many events" do
    user = User.create!(@valid_attributes)
    
    # Create test person for events
    person = Person.create!(name: "Test Person", birth_year: 1980)
    
    event1 = user.events.create!(name: "Event 1", resource: person, data: {test: "data1"})
    event2 = user.events.create!(name: "Event 2", resource: person, data: {test: "data2"})
    
    assert_equal 2, user.events.count
    assert_includes user.events, event1
    assert_includes user.events, event2
  end

  test "should have many favorites with dependent destroy" do
    user = User.create!(@valid_attributes)
    person = Person.create!(name: "Favorite Person", birth_year: 1980)
    
    favorite = user.favorites.create!(person: person)
    assert_equal 1, user.favorites.count
    assert_includes user.favorite_people, person
    
    # Test dependent destroy
    user.destroy
    assert_not Favorite.exists?(favorite.id)
  end

  # RANSACKABLE TESTS
  test "ransackable_attributes returns correct attributes" do
    ransackable_attrs = User.ransackable_attributes
    
    expected_attrs = [
      "confirmation_sent_at", "confirmation_token", "confirmed_at", "created_at",
      "deleted_at", "email", "encrypted_password", "id", "locale", "name",
      "phone", "provider", "remember_created_at", "reset_password_sent_at",
      "reset_password_token", "unconfirmed_email", "updated_at"
    ]
    
    assert_equal expected_attrs, ransackable_attrs
  end

  # EDGE CASES AND ERROR HANDLING
  test "should handle email with mixed case" do
    user = User.create!(@valid_attributes.merge(email: "MiXeD@CaSe.CoM"))
    assert_equal "mixed@case.com", user.email
  end

  test "should handle very long names" do
    long_name = "a" * 255
    user = User.create!(@valid_attributes.merge(name: long_name))
    assert_equal long_name, user.name
  end

  test "should handle special characters in name" do
    special_names = ["José da Silva", "北田太郎", "User-Name_123", "O'Connor"]
    
    special_names.each_with_index do |name, index|
      user = User.create!(@valid_attributes.merge(
        name: name,
        email: "special#{index}@example.com"
      ))
      assert_equal name, user.name
    end
  end

  test "should handle nil locale gracefully" do
    user = User.create!(@valid_attributes)
    user.update_column(:locale, nil)
    
    # Should not crash when accessing locale
    assert_nil user.locale
    assert_not user.pt?
    assert_not user.en?
    assert_not user.ja?
  end

  # CONFIRMATION TESTS
  test "should require email confirmation" do
    user = User.create!(@valid_attributes)
    assert_not user.confirmed?
    assert_not_nil user.confirmation_token
  end

  test "should be able to confirm email" do
    user = User.create!(@valid_attributes)
    user.confirm
    assert user.confirmed?
    assert_not_nil user.confirmed_at
  end

  # PASSWORD RESET TESTS
  test "should be able to generate reset password token" do
    user = User.create!(@valid_attributes)
    user.send_reset_password_instructions
    
    assert_not_nil user.reset_password_token
    assert_not_nil user.reset_password_sent_at
  end

  # DIRTY TRACKING TESTS
  test "should track attribute changes with ActiveModel::Dirty" do
    user = User.create!(@valid_attributes)
    
    user.name = "New Name"
    assert user.name_changed?
    assert_equal ["Test User", "New Name"], user.name_change
    
    user.save!
    assert_not user.name_changed?
  end

  test "should track email changes" do
    user = User.create!(@valid_attributes)
    
    user.email = "newemail@example.com"
    assert user.email_changed?
    assert_includes user.email_change, "test@example.com"
    assert_includes user.email_change, "newemail@example.com"
  end

  # FACTORY HELPER TESTS
  test "User fixtures are properly configured" do
    user_one = users(:one)
    user_two = users(:two)
    
    assert_not_nil user_one
    assert_not_nil user_two
    assert_not_equal user_one.email, user_two.email
  end

  private

  def create_test_user(suffix)
    User.create!(
      name: "Test User #{suffix}",
      email: "test#{suffix}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end
end