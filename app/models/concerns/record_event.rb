# frozen_string_literal: true
#
# This module is used to record events in the database.
module RecordEvent
  extend ActiveSupport::Concern
  include ActiveModel::Dirty

  included do
    attr_accessor :current_user

    after_create { record_create(self) }
    after_update { record_update(self) }
    after_destroy { record_destroy(self) }
  end

  def record_create(resource = self)
    return unless current_user

    changes = saved_changes.transform_values(&:last).reject { |k, v| v.nil? || v == '' || %w[id updated_at].include?(k) }

    current_user.events.create(
      name: "#{self.class.name.underscore}.create",
      data: changes,
      resource:
    )
    if self.class == Couple
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

  def record_update(resource = self)
    return unless current_user

    changes = saved_changes

    current_user.events.create(
      name: "#{self.class.name.underscore}.update",
      data: changes,
      resource:
    )
    if self.class == Couple
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

  # Unlink just for Couple
  def record_destroy(resource = self)
    return unless destroyed_logically? && current_user

    current_user.events.create(
      name: "#{self.class.name.underscore}.unlink",
      data: {
        deleted_at: deleted_at
      },
      resource:
    )
  end

  private

  def destroyed_logically?
    deleted_at.present?
  end
end
