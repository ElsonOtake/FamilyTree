# frozen_string_literal: true

# This model represents a person in the family tree.
class Person < ApplicationRecord
  include GenerateCsv
  include RecordEvent

  acts_as_paranoid

  has_and_belongs_to_many :couples
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [240, 240]
  end
  has_many :events, as: :resource

  validates :name, presence: true
  validates :avatar, content_type: ['image/png', 'image/jpeg'],
                     size: { less_than: 1.megabytes, message: I18n.t('errors.messages.image_size') }

  extend FriendlyId
  friendly_id :slug_candidates, use: %i[slugged finders history]

  enum gender: %i[M F P X]

  scope :without_recorded_parents, -> { where.missing(:couples) }

  before_validation :set_default_gender, on: :create

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

  def mate(couple_id)
    return nil if couple_id.nil?

    couple = Couple.find(couple_id)
    return nil if couple.nil?

    couple.person1_id == id ? Person.find(couple.person2_id) : Person.find(couple.person1_id)
  end

  def mates
    Couple.mates(id)
  end

  def children
    Couple.children(id)
  end

  def birth_date_formatted
    format_partial_date(birth_day, birth_month, birth_year)
  end

  def death_date_formatted
    format_partial_date(death_day, death_month, death_year)
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
    %w[alive birth death description gender name kanji]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def set_default_gender
    self.gender ||= 'M'
  end

  def format_partial_date(day, month, year)
    if day && month && year
      I18n.l(Date.new(year, month, day), format: :day_month_year)
    elsif month && year
      I18n.l(Date.new(year, month, Date.today.day), format: :month_year)
    elsif day && month
      I18n.l(Date.new(Date.today.year, month, day), format: :day_month)
    elsif year
      I18n.l(Date.new(year, Date.today.month, Date.today.day), format: :year)
    else
      ''
    end
  end
end
