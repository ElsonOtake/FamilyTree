# frozen_string_literal: true

# This model represents a person in the family tree.
class Person < ApplicationRecord
  include GenerateCsv

  acts_as_paranoid

  has_and_belongs_to_many :couples
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [240, 240]
  end

  validates :name, presence: true
  validates :avatar, content_type: ['image/png', 'image/jpeg'],
                     size: { less_than: 1.megabytes, message: I18n.t('errors.messages.image_size') }

  extend FriendlyId
  friendly_id :slug_candidates, use: %i[slugged finders history]

  enum gender: %i[M F P X]

  scope :without_recorded_parents, -> { where.missing(:couples) }

  def siblings
    return [] if couples.empty?

    couples.map(&:people).flatten
  end

  def father
    return nil if couples.empty?

    person = Person.find(couples.first.person1_id)
    person.gender == 'M' ? person : Person.find(couples.first.person2_id)
  end

  def mother
    return nil if couples.empty?

    person = Person.find(couples.first.person1_id)
    person.gender != 'M' ? person : Person.find(couples.first.person2_id)
  end

  def mates
    Couple.mates(id)
  end

  def children
    Couple.children(id)
  end

  def slug_candidates
    [
      :name,
      %i[name description]
    ]
  end

  def should_generate_new_friendly_id?
    name_changed?
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[alive birth death description gender name]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
