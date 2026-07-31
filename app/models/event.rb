# frozen_string_literal: true

# This model represents an event in the family tree.
class Event < ApplicationRecord
  include GenerateCsv

  belongs_to :user
  belongs_to :resource, polymorphic: true, optional: true

  validates :name, :data, presence: true

  scope :user_created, -> { where(name: 'user.create') }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name user_id resource_type resource_id created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
