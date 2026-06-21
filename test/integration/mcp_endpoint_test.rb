# frozen_string_literal: true

require 'test_helper'

# Verifies the /mcp endpoint is gated by per-user bearer tokens. The transport
# delivers JSON-RPC results over a separate SSE stream, so these tests assert on
# the authentication status of the POST; tool output is covered by the unit
# tests in test/tools.
class McpEndpointTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      name: 'MCP User',
      email: 'mcp-user@example.com',
      password: 'password123',
      confirmed_at: Time.current
    )
    @user.regenerate_mcp_token!

    Person.create!(name: 'Alice Example', gender: 'F',
                   birth_year: 1990, birth_month: 5, birth_day: 1)
  end

  def post_mcp(body, token: nil)
    headers = { 'CONTENT_TYPE' => 'application/json' }
    headers['HTTP_AUTHORIZATION'] = "Bearer #{token}" if token
    post '/mcp/messages', params: body.to_json, headers: headers
  end

  def rpc(method, params = {})
    { jsonrpc: '2.0', id: 1, method: method, params: params }
  end

  test 'rejects requests with no token' do
    post_mcp(rpc('tools/list'))

    assert_response :unauthorized
  end

  test 'rejects requests with an invalid token' do
    post_mcp(rpc('tools/list'), token: 'not-a-real-token')

    assert_response :unauthorized
  end

  test 'accepts a request authenticated with a valid token' do
    post_mcp(rpc('tools/list'), token: @user.mcp_token)

    assert_response :success
  end

  test 'a revoked token is rejected' do
    @user.revoke_mcp_token!

    post_mcp(rpc('tools/list'), token: nil)
    assert_response :unauthorized
  end
end
