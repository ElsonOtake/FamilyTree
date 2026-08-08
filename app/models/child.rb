# frozen_string_literal: true

# A child is a person who is a member of a couple.
# The person_id is the child and the couple_id is the couple.
class Child < ApplicationRecord

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

  # Record events when children are added or removed. Re-linking (restore) is
  # audited explicitly via #record_relink from the controller, not an
  # after_restore hook: paranoia runs :restore callbacks unconditionally (even
  # for no-op or out-of-recovery-window restores and for admin cascade restores
  # where the actor is unknown), which would mint phantom/duplicate events.
  after_create :record_child_added
  after_destroy :record_child_removed

  # Audit a manual re-link (a restored soft-deleted row) as a fresh add.
  def record_relink(user)
    self.current_user = user
    record_child_added
  end

  private

  def record_child_added
    event_user('record_child_added').events.create(
      name: 'child.create',
      data: {
        couple_id: couple_id,
        person_id: person_id
      },
      resource: person
    )
  end

  def record_child_removed
    event_user('record_child_removed').events.create(
      name: 'child.unlink',
      data: {
        couple_id: couple_id,
        person_id: person_id
      },
      resource: person
    )
  end

  # Prefer the explicitly-set actor, then the request-wide Current.user (set for
  # cascaded destroys where current_user isn't threaded through), then fall back.
  def event_user(action)
    current_user || Current.user || system_user_with_warning(action)
  end

  def system_user_with_warning(action)
    Rails.logger.warn("Child##{action}: Using system user - current_user not set for person_id=#{person_id}, couple_id=#{couple_id}")
    User.system_user
  end
end
