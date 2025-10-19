# frozen_string_literal: true

# A child is a person who is a member of a couple.
# The person_id is the child and the couple_id is the couple.
class Child < ApplicationRecord
  include GenerateCsv

  # This model represents the couples_people join table
  self.table_name = 'couples_people'
  self.primary_key = [:person_id, :couple_id]

  belongs_to :couple
  belongs_to :person

  attr_accessor :current_user

  validates :person_id, uniqueness: { scope: :couple_id }

  # Record events when children are added or removed
  after_create :record_child_added
  after_destroy :record_child_removed

  private

  def record_child_added
    unless current_user
      Rails.logger.warn("Child#record_child_added: Event not recorded - current_user not set for person_id=#{person_id}, couple_id=#{couple_id}")
      return
    end

    current_user.events.create(
      name: 'child.create',
      data: {
        couple_id: couple_id,
        person_id: person_id
      },
      resource: person
    )
  end

  def record_child_removed
    unless current_user
      Rails.logger.warn("Child#record_child_removed: Event not recorded - current_user not set for person_id=#{person_id}, couple_id=#{couple_id}")
      return
    end

    current_user.events.create(
      name: 'child.unlink',
      data: {
        couple_id: couple_id,
        person_id: person_id
      },
      resource: person
    )
  end
end
