# frozen_string_literal: true

require 'test_helper'
require 'minitest/mock'

# Every MCP tool call is recorded as an "mcp.<tool>" audit Event attributed to
# the authenticated caller (Current.user, set by the token transport). See
# ApplicationTool#call_with_schema_validation!.
class McpInteractionLoggingTest < ActiveSupport::TestCase
  def setup
    @caller = User.create!(name: 'MCP Caller', email: "caller-#{SecureRandom.hex(4)}@example.com",
                           password: 'password123', confirmed_at: Time.current)
    @person = Person.create!(name: 'Root Doe', gender: 'M')
  end

  def teardown
    Current.user = nil
  end

  test 'a tool call records an mcp event attributed to the caller with its arguments' do
    Current.user = @caller

    assert_difference -> { @caller.events.where(name: 'mcp.get_parents').count }, 1 do
      GetParentsTool.new.call_with_schema_validation!(person_id: @person.id.to_s)
    end

    event = @caller.events.where(name: 'mcp.get_parents').order(:id).last
    assert_equal 'get_parents', event.data['tool']
    assert_equal @person.id.to_s, event.data['arguments']['person_id']
    assert_equal @caller, event.user
  end

  test 'a not-found lookup is still recorded' do
    Current.user = @caller

    assert_difference -> { Event.where(name: 'mcp.get_age').count }, 1 do
      GetAgeTool.new.call_with_schema_validation!(person_id: '999999')
    end
  end

  test 'no event is recorded without an authenticated caller' do
    Current.user = nil

    assert_no_difference -> { Event.count } do
      GetParentsTool.new.call_with_schema_validation!(person_id: @person.id.to_s)
    end
  end

  test 'a failed audit write never breaks the tool response' do
    Current.user = @caller

    # Make the audit write raise; the query result must still come back intact.
    boom = Object.new
    boom.define_singleton_method(:create!) { |*| raise 'audit down' }

    @caller.stub(:events, boom) do
      result, = GetParentsTool.new.call_with_schema_validation!(person_id: @person.id.to_s)
      assert_equal 'Root Doe', JSON.parse(result)['person']['name']
    end
  end
end
