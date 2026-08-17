require 'test_helper'

class ApplicationPolicyTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @record = Object.new
    @policy = ApplicationPolicy.new(@user, @record)
  end

  # INITIALIZATION TESTS
  test "policy initializes correctly with user and record" do
    assert_equal @user, @policy.user
    assert_equal @record, @policy.record
  end

  test "policy can be initialized with nil user" do
    policy = ApplicationPolicy.new(nil, @record)
    assert_nil policy.user
    assert_equal @record, policy.record
  end

  test "policy can be initialized with nil record" do
    policy = ApplicationPolicy.new(@user, nil)
    assert_equal @user, policy.user
    assert_nil policy.record
  end

  # DEFAULT PERMISSION TESTS
  test "index? denies access by default" do
    assert_not @policy.index?
  end

  test "show? denies access by default" do
    assert_not @policy.show?
  end

  test "create? denies access by default" do
    assert_not @policy.create?
  end

  test "new? delegates to create?" do
    # Should return false since create? returns false by default
    assert_not @policy.new?
    assert_equal @policy.create?, @policy.new?
  end

  test "update? denies access by default" do
    assert_not @policy.update?
  end

  test "edit? delegates to update?" do
    # Should return false since update? returns false by default
    assert_not @policy.edit?
    assert_equal @policy.update?, @policy.edit?
  end

  test "destroy? denies access by default" do
    assert_not @policy.destroy?
  end

  # DELEGATION TESTS
  test "new? always returns same as create?" do
    # Create a test policy that overrides create?
    test_policy_class = Class.new(ApplicationPolicy) do
      def create?
        true
      end
    end

    policy = test_policy_class.new(@user, @record)
    assert policy.create?
    assert policy.new?
    assert_equal policy.create?, policy.new?
  end

  test "edit? always returns same as update?" do
    # Create a test policy that overrides update?
    test_policy_class = Class.new(ApplicationPolicy) do
      def update?
        true
      end
    end

    policy = test_policy_class.new(@user, @record)
    assert policy.update?
    assert policy.edit?
    assert_equal policy.update?, policy.edit?
  end

  # SCOPE TESTS
  test "Scope initializes correctly with user and scope" do
    scope = "test_scope"
    policy_scope = ApplicationPolicy::Scope.new(@user, scope)
    
    assert_equal @user, policy_scope.send(:user)
    assert_equal scope, policy_scope.send(:scope)
  end

  test "Scope resolve raises NotImplementedError" do
    scope = "test_scope"
    policy_scope = ApplicationPolicy::Scope.new(@user, scope)
    
    error = assert_raises(NotImplementedError) do
      policy_scope.resolve
    end
    
    assert_includes error.message, "You must define #resolve in"
    assert_includes error.message, policy_scope.class.to_s
  end

  test "Scope can be subclassed and resolve implemented" do
    test_scope_class = Class.new(ApplicationPolicy::Scope) do
      def resolve
        scope.where(user: user)
      end
    end

    # Mock scope object with where method
    mock_scope = Object.new
    def mock_scope.where(conditions)
      "filtered_scope_with_#{conditions}"
    end

    policy_scope = test_scope_class.new(@user, mock_scope)
    result = policy_scope.resolve
    
    # Check that the result contains the expected pattern instead of exact match
    # since User object representation can vary
    assert_includes result, "filtered_scope_with_"
    assert_includes result, "user:" # Ruby 3.4 renders hashes as {user: ...}, not {:user=>...}
    assert_includes result, @user.id.to_s # email is [FILTERED] in User#inspect, so match the id
  end

  # INHERITANCE TESTS
  test "subclassed policies inherit default behavior" do
    test_policy_class = Class.new(ApplicationPolicy)
    policy = test_policy_class.new(@user, @record)
    
    # Should inherit all default denials
    assert_not policy.index?
    assert_not policy.show?
    assert_not policy.create?
    assert_not policy.new?
    assert_not policy.update?
    assert_not policy.edit?
    assert_not policy.destroy?
  end

  test "subclassed policies can override specific methods" do
    test_policy_class = Class.new(ApplicationPolicy) do
      def show?
        true
      end
      
      def create?
        user.present?
      end
    end

    policy = test_policy_class.new(@user, @record)
    
    # Overridden methods
    assert policy.show?
    assert policy.create?
    assert policy.new? # Should delegate to create?
    
    # Non-overridden methods should still use defaults
    assert_not policy.index?
    assert_not policy.update?
    assert_not policy.edit?
    assert_not policy.destroy?
  end

  # NIL USER HANDLING TESTS
  test "all default methods handle nil user gracefully" do
    policy = ApplicationPolicy.new(nil, @record)
    
    assert_not policy.index?
    assert_not policy.show?
    assert_not policy.create?
    assert_not policy.new?
    assert_not policy.update?
    assert_not policy.edit?
    assert_not policy.destroy?
  end

  # POLICY CONSTANTS AND STRUCTURE TESTS
  test "ApplicationPolicy is a class" do
    assert ApplicationPolicy.is_a?(Class)
  end

  test "ApplicationPolicy::Scope is a nested class" do
    assert ApplicationPolicy::Scope.is_a?(Class)
    # ApplicationPolicy::Scope is defined as a nested class inside ApplicationPolicy
    assert_equal "ApplicationPolicy::Scope", ApplicationPolicy::Scope.name
  end

  test "policy responds to all expected methods" do
    expected_methods = [:index?, :show?, :create?, :new?, :update?, :edit?, :destroy?, :user, :record]
    
    expected_methods.each do |method|
      assert_respond_to @policy, method, "Policy should respond to #{method}"
    end
  end

  test "scope responds to expected methods" do
    scope = ApplicationPolicy::Scope.new(@user, @record)
    expected_methods = [:resolve]
    
    expected_methods.each do |method|
      assert_respond_to scope, method, "Scope should respond to #{method}"
    end
  end

  # EDGE CASES
  test "policy works with various record types" do
    [nil, "", 0, [], {}, Object.new].each do |record|
      policy = ApplicationPolicy.new(@user, record)
      assert_equal record, policy.record
      assert_not policy.index? # Should still deny by default
    end
  end

  test "policy maintains attribute reader behavior" do
    # Test that user and record are properly accessible
    assert_equal @user, @policy.user
    assert_equal @record, @policy.record
    
    # Test that they are read-only (no writers defined)
    assert_not_respond_to @policy, :user=
    assert_not_respond_to @policy, :record=
  end
end