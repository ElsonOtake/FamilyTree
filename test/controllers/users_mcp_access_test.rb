# frozen_string_literal: true

require 'test_helper'

# Covers the self-service MCP access page and token actions.
class UsersMcpAccessTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: 'Member', email: 'member@example.com',
                         password: 'password123', confirmed_at: Time.current, approved: true)
    sign_in_as(@user)
  end

  def sign_in_as(user)
    post user_session_path, params: { user: { email: user.email, password: 'password123' } }
  end

  def sign_out_user
    delete destroy_user_session_path
  end

  test 'mcp_access page renders for a signed-in user' do
    get mcp_access_users_path

    assert_response :success
    assert_select 'h1', text: I18n.t('users.mcp_access.title')
  end

  test 'enabling generates a token' do
    assert_nil @user.reload.mcp_token

    post regenerate_mcp_token_users_path

    assert_redirected_to mcp_access_users_path
    assert @user.reload.mcp_token.present?
  end

  test 'revoking clears the token' do
    @user.regenerate_mcp_token!

    delete revoke_mcp_token_users_path

    assert_redirected_to mcp_access_users_path
    assert_nil @user.reload.mcp_token
  end

  test 'the page is gated behind authentication' do
    sign_out_user

    get mcp_access_users_path

    assert_redirected_to new_user_session_path
  end
end
