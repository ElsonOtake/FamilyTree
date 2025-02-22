# frozen_string_literal: true

# Policy for the person model
class PersonPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user, person)
    super
    @user = user
    @person = person
  end

  def index?
    true
  end

  def download?
    user.has_role? :admin
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

  def search_child?
    new?
  end

  def search_mate?
    new?
  end
end
