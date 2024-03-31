class UserPolicy < ApplicationPolicy
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
