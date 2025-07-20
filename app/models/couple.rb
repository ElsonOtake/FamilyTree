# frozen_string_literal: true

# A couple is a pair of people. The order of the people is important, person1_id must be less than person2_id. This way is possible to avoid duplicates.
class Couple < ApplicationRecord
  include GenerateCsv
  include RecordEvent

  acts_as_paranoid

  has_and_belongs_to_many :people
  belongs_to :person1, class_name: 'Person', foreign_key: 'person1_id'
  belongs_to :person2, class_name: 'Person', foreign_key: 'person2_id'

  before_save :order_people

  validates :person1_id, :person2_id, presence: true

  def order_people
    self.person1_id, self.person2_id = person2_id, person1_id if person1_id > person2_id
  end

  def self.couple(person1, person2)
    return nil if person1.nil? || person2.nil?

    person1, person2 = person2, person1 if person1.id > person2.id
    Couple.find_by(person1_id: person1, person2_id: person2)
  end

  def self.mates(person_id)
    return [] if person_id.nil?

    couples = Couple.includes(:person1, :person2)
                   .where(person1_id: person_id)
                   .or(Couple.includes(:person1, :person2).where(person2_id: person_id))
    return [] if couples.empty?

    # Use already loaded associations
    couples.map { |couple| couple.person1_id != person_id ? couple.person1 : couple.person2 }
  end

  def self.children(person_id)
    return [] if person_id.nil?

    couples = Couple.includes(:people)
                   .where(person1_id: person_id)
                   .or(Couple.includes(:people).where(person2_id: person_id))
    return [] if couples.empty?

    # Use flat_map to avoid nested arrays and get unique children
    couples.flat_map(&:people).uniq
  end

  def self.ransackable_associations(auth_object = nil)
    %w[person1 person2]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at local marriage separation updated_at couple_person1_name_or_couple_person2_name]
  end
end
