require "test_helper"

class Users::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user.update!(confirmed_at: nil)
  end

  # Generate a real Devise confirmation token and return the raw value to use in a request.
  def issue_confirmation_token
    raw, enc = Devise.token_generator.generate(User, :confirmation_token)
    @user.update!(confirmation_token: enc, confirmation_sent_at: Time.current, confirmed_at: nil)
    raw
  end

  # STRUCTURE
  test "inherits from Devise::ConfirmationsController" do
    assert Users::ConfirmationsController < Devise::ConfirmationsController
  end

  test "is namespaced under Users" do
    assert_equal "Users::ConfirmationsController", Users::ConfirmationsController.name
  end

  test "responds to the standard Devise confirmation actions" do
    controller = Users::ConfirmationsController.new
    %i[show new create].each { |m| assert_respond_to controller, m }
  end

  test "only overrides the private after_confirmation_path_for" do
    assert_empty Users::ConfirmationsController.instance_methods(false),
                 "should not override public Devise methods"
    assert_includes Users::ConfirmationsController.private_instance_methods(false),
                    :after_confirmation_path_for
  end

  test "confirmation routes resolve to this controller" do
    assert_routing({ method: "get", path: "/users/confirmation/new" },
                   { controller: "users/confirmations", action: "new" })
    assert_routing({ method: "post", path: "/users/confirmation" },
                   { controller: "users/confirmations", action: "create" })
    assert_routing({ method: "get", path: "/users/confirmation" },
                   { controller: "users/confirmations", action: "show" })
  end

  # FORMS
  test "new renders the resend-confirmation form" do
    get new_user_confirmation_path
    assert_response :success
    assert_select "form[action=?]", user_confirmation_path
  end

  test "the resend form renders in different locales" do
    %i[pt en ja].each do |locale|
      I18n.with_locale(locale) do
        get new_user_confirmation_path
        assert_response :success
      end
    end
  end

  # CONFIRMATION FLOW (exercises the custom after_confirmation_path_for)
  test "confirming with a valid token confirms the user and redirects to root" do
    raw_token = issue_confirmation_token

    get user_confirmation_path(confirmation_token: raw_token)

    assert_redirected_to root_path
    assert @user.reload.confirmed?
  end

  test "after confirmation the user is signed in (root is reachable)" do
    raw_token = issue_confirmation_token

    get user_confirmation_path(confirmation_token: raw_token)
    follow_redirect!

    assert_response :success # root requires authentication, so reaching it proves sign-in
  end

  test "an invalid confirmation token re-renders the form" do
    get user_confirmation_path(confirmation_token: "invalid")
    assert_response :success
  end

  # RESEND
  test "resending to a known email redirects" do
    post user_confirmation_path, params: { user: { email: @user.email } }
    assert_response :redirect
  end

  test "resending to an unknown email re-renders with errors" do
    post user_confirmation_path, params: { user: { email: "nobody@example.com" } }
    assert_response :unprocessable_entity
  end

  test "resending to a blank email re-renders with errors" do
    post user_confirmation_path, params: { user: { email: "" } }
    assert_response :unprocessable_entity
  end
end
