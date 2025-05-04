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

    changes = saved_changes.transform_values(&:last).reject { |k, v| v.nil? || v == '' || %w[id updated_at].include?(k) }

    if self.class == Person
      current_user.events.create(
        name: "#{self.class.name.underscore}.create",
        data: changes,
        resource: self
      )
    else
      current_user.events.create(
        name: "#{self.class.name.underscore}.create",
        data: changes,
        resource: Person.find(self.person1_id)
      )
      current_user.events.create(
        name: "#{self.class.name.underscore}.create",
        data: changes,
        resource: Person.find(self.person2_id)
      )
    end
  end

  def record_update
    return unless current_user

    changes = saved_changes

    if self.class == Person
      current_user.events.create(
        name: "#{self.class.name.underscore}.update",
        data: changes,
        resource: self
      )
    else
      current_user.events.create(
        name: "#{self.class.name.underscore}.update",
        data: changes,
        resource: Person.find(self.person1_id)
      )
      current_user.events.create(
        name: "#{self.class.name.underscore}.update",
        data: changes,
        resource: Person.find(self.person2_id)
      )
    end
  end

  def record_destroy
    return unless destroyed_logically? && current_user

    current_user.events.create(
      name: "#{self.class.name.underscore}.unlink",
      data: {
        deleted_at: deleted_at
      },
      resource: Person.find(self.person1_id)
    )
    current_user.events.create(
      name: "#{self.class.name.underscore}.unlink",
      data: {
        deleted_at: deleted_at
      },
      resource: Person.find(self.person2_id)
    )
  end

  private

  def destroyed_logically?
    deleted_at.present?
  end
end
