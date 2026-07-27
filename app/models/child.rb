# frozen_string_literal: true

# A child is a person who is a member of a couple.
# The person_id is the child and the couple_id is the couple.
class Child < ApplicationRecord
  include GenerateCsv

  # This model represents the couples_people join table
  self.table_name = 'couples_people'
  self.primary_key = [:person_id, :couple_id]

  # Soft-delete the couple<->child link so unlinking (and cascades from a
  # soft-deleted person/couple) can be restored. The table's composite PK
  # (person_id, couple_id) still allows only one row per pair, so re-adding a
  # previously unlinked child must restore that row rather than insert a
  # duplicate (see ChildrenController#create).
  acts_as_paranoid

  belongs_to :couple
  belongs_to :person

  attr_accessor :current_user

  validates :person_id, uniqueness: { scope: :couple_id }

  # Record events when children are added or removed
  after_create :record_child_added
  after_destroy :record_child_removed

  private

  def record_child_added
    user = current_user || system_user_with_warning('record_child_added')

    user.events.create(
      name: 'child.create',
      data: {
        couple_id: couple_id,
        person_id: person_id
      },
      resource: person
    )
  end

  def record_child_removed
    user = current_user || system_user_with_warning('record_child_removed')

    user.events.create(
      name: 'child.unlink',
      data: {
        couple_id: couple_id,
        person_id: person_id
      },
      resource: person
    )
  end

  def system_user_with_warning(action)
    Rails.logger.warn("Child##{action}: Using system user - current_user not set for person_id=#{person_id}, couple_id=#{couple_id}")
    User.system_user
  end
end
