# frozen_string_literal: true

# Policy for the role model
class RolePolicy < ApplicationPolicy
  def download?
    user.has_role? :admin
  end
end
