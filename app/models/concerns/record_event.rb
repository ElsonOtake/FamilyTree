# frozen_string_literal: true

# Records create/update/unlink audit events for the including model (Person and
# Couple). The acting user is whoever is set on the record, falling back to the
# request-wide Current.user — so admin, console-with-Current and cascaded writes
# are audited too, not only writes that thread `current_user` through explicitly.
# Bulk contexts (seeds, migrations) set neither and are deliberately not logged.
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
    actor = event_actor
    return unless actor

    changes = saved_changes.transform_values(&:last).reject { |k, v| v.nil? || v == '' || %w[id updated_at].include?(k) }
    record_event(actor, 'create', changes)
  end

  def record_update
    actor = event_actor
    return unless actor

    record_event(actor, 'update', saved_changes)
  end

  # Couple-only: a Couple soft-delete is an "unlink" of its two people. Person
  # deletion is audited separately as a person.destroy event (PeopleController),
  # so skip it here — a Person has no person1_id/person2_id to resolve.
  def record_destroy
    return if is_a?(Person)

    actor = event_actor
    return unless destroyed_logically? && actor

    record_event(actor, 'unlink', { deleted_at: deleted_at })
  end

  private

  def event_actor
    current_user || Current.user
  end

  def record_event(actor, action, data)
    name = "#{self.class.name.underscore}.#{action}"
    # with_deleted: a couple can outlive a soft-deleted member, and Person.find
    # (paranoia default scope) would raise RecordNotFound while auditing it.
    people = is_a?(Person) ? [self] : [person1_id, person2_id].map { |id| Person.with_deleted.find_by(id: id) }
    people.compact.each { |person| actor.events.create(name: name, data: data, resource: person) }
  end

  def destroyed_logically?
    deleted_at.present?
  end
end
