# frozen_string_literal: true
#
# This module is used to record events in the database.
# 
module RecordEvent
  extend ActiveSupport::Concern
  include ActiveModel::Dirty

  included do
    attr_accessor :current_user

    # before_save :record_event
    after_create :record_create
    after_update :record_update
    after_destroy :record_destroy
  end

  def record_event
    
    # binding.pry
    
    return unless changed? || destroyed_logically?
    # Check if the current_user is present
    return unless current_user

    if destroyed_logically?
      puts "**************************************** record_event name: #{self.class.name.underscore}.unlink user_id: #{current_user.id} data: { id: #{id}, deleted_at: #{deleted_at} }"
    else
      puts "**************************************** record_event name: #{self.class.name.underscore} user_id: #{current_user.id} data: { id: #{id}, changes: #{changes}, saved_changes: #{saved_changes} }"
    end

    # Event.create(class: , id: , changes: , user_id:)
  end

  def record_create
    
    # binding.pry
    
    # return unless changed? || destroyed_logically?
    # Check if the current_user is present
    return unless current_user

    puts "**************************************** record_event name: #{self.class.name.underscore}.create user_id: #{current_user.id} data: { id: #{id}, saved_changes: #{saved_changes} }"

    # Event.create(class: , id: , changes: , user_id:)
  end

  def record_update
    
    # binding.pry
    
    # return unless changed? || destroyed_logically?
    # Check if the current_user is present
    return unless current_user

    puts "**************************************** record_event name: #{self.class.name.underscore}.update user_id: #{current_user.id} data: { id: #{id}, saved_changes: #{saved_changes} }"

    # Event.create(class: , id: , changes: , user_id:)
  end


  def record_destroy
    
    # binding.pry
    
    return unless destroyed_logically?
    # Check if the current_user is present
    return unless current_user

    puts "**************************************** record_event name: #{self.class.name.underscore}.unlink user_id: #{current_user.id} data: { id: #{id}, deleted_at: #{deleted_at} }"

    # Event.create(class: , id: , changes: , user_id:)
  end

  private

  def destroyed_logically?
    deleted_at.present?
  end
end
