class CouplePolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user, couple)
    @user = user
    @couple = couple
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
end
