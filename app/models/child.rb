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

  def register_event(child, couple, user, action)
    puts "**************************************** record_event name: #{action} user_id: #{user.id} data: { person: #{child.id}, couple_id: #{couple.id} }"

    # Aqui você pode criar o evento no banco de dados
    # Event.create(model: 'Child', action: action, child_id: child.id, couple_id: couple.id, user_id: user.id)
  end
end
