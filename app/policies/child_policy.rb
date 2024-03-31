class ChildPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user, _record)
    @user = user
  end

  def index?
    true
  end
  
  def show?
    true
  end
  
  def new?
    user.has_any_role? :silver, :gold, :admin
  end
  
  def edit?
    new?
  end
  
  def create?
    new?
  end
  
  def update?
    new?
  end
  
  def destroy?
    user.has_any_role? :gold, :admin
  end
end