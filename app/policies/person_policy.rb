class PersonPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user, person)
    @user = user
    @person = person
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
    user.has_any_role? :silver, :gold, :admin
  end
  
  def create?
    user.has_any_role? :silver, :gold, :admin
  end
  
  def update?
    user.has_any_role? :silver, :gold, :admin
  end
  
  def destroy?
    user.has_any_role? :gold, :admin
  end
  
  def search_child?
    user.has_any_role? :silver, :gold, :admin
  end
  
  def search_mate?
    user.has_any_role? :silver, :gold, :admin
  end
end