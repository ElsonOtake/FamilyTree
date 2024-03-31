class UserPolicy < ApplicationPolicy
  def roles?
    user.has_role? :admin
  end
end
