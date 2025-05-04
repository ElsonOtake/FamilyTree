# frozen_string_literal: true

# A child is a person who is a member of a couple.
# The person_id is the child and the couple_id is the couple.
class Child < ApplicationRecord
  include GenerateCsv

  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :person_id, :integer
  attribute :couple_id, :integer

  def self.all
    Person.joins(:couples).select('person_id, couple_id')
  end

  def self.column_names
    attribute_names
  end

  def register_event(person, couple, user, action)
    user.events.create(
      name: action,
      data: {
        couple_id: couple.id
      },
      resource: Person.find(person.id)
    )
  end
end
