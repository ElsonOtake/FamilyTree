# frozen_string_literal: true

require 'test_helper'

# Covers the opt-in MCP token lifecycle on User.
class UserMcpTokenTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      name: 'Token User',
      email: 'token-user@example.com',
      password: 'password123',
      confirmed_at: Time.current
    )
  end

  test 'new users have no token by default (opt-in)' do
    assert_nil @user.mcp_token
    assert_not @user.mcp_enabled?
  end

  test 'regenerate_mcp_token! creates a token and enables access' do
    @user.regenerate_mcp_token!

    assert @user.mcp_token.present?
    assert @user.mcp_enabled?
  end

  test 'regenerate_mcp_token! rotates the token' do
    @user.regenerate_mcp_token!
    first = @user.mcp_token
    @user.regenerate_mcp_token!

    assert_not_equal first, @user.mcp_token
  end

  test 'revoke_mcp_token! disables access' do
    @user.regenerate_mcp_token!
    @user.revoke_mcp_token!

    assert_nil @user.mcp_token
    assert_not @user.mcp_enabled?
  end

  test 'find_by_mcp_token resolves the owner and ignores blanks' do
    @user.regenerate_mcp_token!

    assert_equal @user, User.find_by_mcp_token(@user.mcp_token)
    assert_nil User.find_by_mcp_token(nil)
    assert_nil User.find_by_mcp_token('')
    assert_nil User.find_by_mcp_token('wrong')
  end
end
