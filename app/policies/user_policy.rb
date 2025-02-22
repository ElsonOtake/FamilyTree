# frozen_string_literal: true

# Policy for the user model
class UserPolicy < ApplicationPolicy
  def index?
    user.has_role? :admin
  end

  def roles?
    user.has_role? :admin
  end

  def role_update?
    user.has_role? :admin
  end

  def change?
    true
  end

  def change_unidentified?
    true
  end
end
