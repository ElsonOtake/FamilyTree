# frozen_string_literal: true
#
# This module is used to record events in the database.
# 
module RecordEvent
  extend ActiveSupport::Concern
  include ActiveModel::Dirty

  included do
    attr_accessor :current_user

    before_save :record_event
    after_destroy :record_event
  end

  def record_event
    
    # binding.pry
    
    return unless changed? || destroyed_logically?
    # Check if the current_user is present
    return unless current_user

    puts "**************************************** record_event class: #{self.class.name.underscore} id: #{id} changes: #{changes} deleted_at: #{deleted_at} user_id: #{current_user.id}"

    # Event.create(class: , id: , changes: , user_id:)
  end

  private

  def destroyed_logically?
    deleted_at.present?
  end
end
