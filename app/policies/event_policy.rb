# frozen_string_literal: true

# Policy for the event model
class EventPolicy < ApplicationPolicy
  def download?
    user&.has_role? :admin
  end
end
