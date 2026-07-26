# frozen_string_literal: true

# Policy for the user model
class UserPolicy < ApplicationPolicy
  def index?
    user&.has_role? :admin
  end

  def roles?
    user&.has_role? :admin
  end

  def role_update?
    user&.has_role? :admin
  end

  def change?
    true
  end

  # Any signed-in user may view and manage their own MCP access token.
  def mcp_access?
    user.present?
  end

  def regenerate_mcp_token?
    mcp_access?
  end

  def revoke_mcp_token?
    mcp_access?
  end

  # Any signed-in user may view and update their own tree export settings.
  def tree_settings?
    user.present?
  end

  def update_tree_settings?
    tree_settings?
  end

  def change_unidentified?
    true
  end

  def download?
    user&.has_role? :admin
  end
end
