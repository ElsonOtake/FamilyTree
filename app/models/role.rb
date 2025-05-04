# frozen_string_literal: true

# Role model
class Role < ApplicationRecord
  include GenerateCsv

  acts_as_paranoid

  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true, optional: true
  validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true

  scopify

  def self.ransackable_associations(auth_object = nil)
    ["resource", "users"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "deleted_at", "id", "name", "resource_id", "resource_type", "updated_at"]
  end
end
