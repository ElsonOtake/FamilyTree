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
end
