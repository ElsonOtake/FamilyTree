# frozen_string_literal: true

# Role model
class Role < ApplicationRecord
  acts_as_paranoid

  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true, optional: true
  validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true

  scopify

  def self.ransackable_associations(_auth_object = nil)
    %w[resource users]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at deleted_at id name resource_id resource_type updated_at]
  end
end
