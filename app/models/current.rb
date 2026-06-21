# frozen_string_literal: true

# Request-scoped global state. Reset automatically by the Rails executor
# between requests. The MCP transport assigns +user+ after authenticating a
# bearer token so tools can attribute queries to the calling user.
class Current < ActiveSupport::CurrentAttributes
  attribute :user
end
