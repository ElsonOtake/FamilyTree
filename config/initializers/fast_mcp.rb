# frozen_string_literal: true

# Mounts the Model Context Protocol (MCP) server at /mcp.
#
# Unlike FastMcp.mount_in_rails, we insert our own transport
# (FamilyTreeTokenTransport) so each request is authenticated against a
# per-user bearer token (User#mcp_token) rather than a single static token.
#
# Tools live in app/tools and are auto-discovered as ApplicationTool
# descendants. They are read-only queries over the family tree.
require 'fast_mcp'

# Rack transport that authenticates each MCP request against a per-user bearer
# token (User#mcp_token) instead of fast-mcp's single static token. On a valid
# token the matching User is stashed in Current.user for the request so tools
# can attribute queries to the caller (the Rails executor resets Current between
# requests).
#
# Defined here rather than under app/ because the middleware stack is built
# during initialization, before Zeitwerk-managed app constants can be safely
# autoloaded.
class FamilyTreeTokenTransport < FastMcp::Transports::AuthenticatedRackTransport
  private

  # Auth is always on for this transport (the base class only enables it when a
  # static :auth_token is configured, which we deliberately don't set).
  def auth_enabled?
    true
  end

  def valid_token?(token)
    user = User.find_by_mcp_token(token)
    return false if user.nil?

    Current.user = user
    true
  end
end

mcp_server = FastMcp::Server.new(
  name: 'family-tree',
  version: '1.0.0',
  logger: Rails.logger
)
FastMcp.server = mcp_server

# Register tools once the app is fully loaded. fast-mcp's railtie force-requires
# everything under app/tools in an earlier after_initialize hook, so all
# ApplicationTool descendants exist by the time this runs.
Rails.application.config.after_initialize do
  mcp_server.register_tools(*ApplicationTool.descendants)
end

# Insert just before Warden so MCP's 401 responses go straight back to the
# client instead of being intercepted by Devise's failure handling. This keeps
# the middleware inside ActionDispatch::Executor (which manages the DB
# connection and resets Current between requests).
Rails.application.config.middleware.insert_before(
  Warden::Manager,
  FamilyTreeTokenTransport,
  mcp_server,
  path_prefix: '/mcp',
  messages_route: 'messages',
  sse_route: 'sse',
  logger: Rails.logger,
  allowed_origins: FastMcp.default_rails_allowed_origins(Rails.application),
  localhost_only: Rails.env.local?,
  allowed_ips: FastMcp::Transports::RackTransport::DEFAULT_ALLOWED_IPS
)
