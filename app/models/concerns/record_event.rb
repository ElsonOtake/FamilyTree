# frozen_string_literal: true
#
# This module is used to record events in the database.
module RecordEvent
  extend ActiveSupport::Concern
  include ActiveModel::Dirty

  included do
    attr_accessor :current_user

    after_create :record_create
    after_update :record_update
    after_destroy :record_destroy
  end

  def record_create
    return unless current_user

    changes_with_id = saved_changes.transform_values(&:last).reject { |k, v| v.nil? || v == '' || %w[id updated_at].include?(k) }
    changes_with_id["#{self.class.name.underscore}_id"] = id

    current_user.events.create(
      name: "#{self.class.name.underscore}.create",
      data: changes_with_id
    )
  end

  def record_update
    return unless current_user

    changes_with_id = saved_changes
    changes_with_id["#{self.class.name.underscore}_id"] = id

    current_user.events.create(
      name: "#{self.class.name.underscore}.update",
      data: changes_with_id
    )
  end

  def record_destroy
    return unless destroyed_logically? && current_user

    key = "#{self.class.name.underscore}_id".to_sym

    current_user.events.create(
      name: "#{self.class.name.underscore}.unlink",
      data: {
        key => id,
        deleted_at: deleted_at
      }
    )
  end

  private

  def destroyed_logically?
    deleted_at.present?
  end
end
