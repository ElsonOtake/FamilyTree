# frozen_string_literal: true

# Policy for the couple model
class CouplePolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user, couple)
    super
    @user = user
    @couple = couple
  end

  def index?
    true
  end

  def download?
    user&.has_role? :admin
  end

  def show?
    true
  end

  def new?
    user&.has_any_role? :silver, :gold, :admin
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
    user&.has_any_role? :gold, :admin
  end
end
