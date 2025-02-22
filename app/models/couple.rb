# frozen_string_literal: true

# A couple is a pair of people. The order of the people is important, person1_id must be less than person2_id.
class Couple < ApplicationRecord
  include GenerateCsv

  acts_as_paranoid

  has_and_belongs_to_many :people

  before_save :order_people

  validates :person1_id, :person2_id, presence: true

  def order_people
    self.person1_id, self.person2_id = person2_id, person1_id if person1_id > person2_id
  end
end
