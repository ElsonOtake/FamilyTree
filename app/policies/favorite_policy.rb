# frozen_string_literal: true

# Policy for the favorite model
class FavoritePolicy < ApplicationPolicy
  attr_reader :user, :favorite

  def initialize(user, favorite)
    super
    @user = user
    @favorite = favorite
  end

  def index?
    user.present?
  end

  def create?
    user.present?
  end

  def destroy?
    user.present? && favorite&.user == user
  end
end