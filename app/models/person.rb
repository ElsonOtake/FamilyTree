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

  def date_text
    if death_year
      if birth_year
        "#{I18n.t('people.person.passed_away_on_years_of_age', date: formatted_long_date(death_year, death_month, death_day), age: formatted_age(birth_year, birth_month, birth_day, death_year, death_month, death_day))}"
      else
        "#{I18n.t('people.person.passed_away_on', date: formatted_long_date(death_year, death_month, death_day))}"
      end
    elsif birth_year && alive?
      formatted_age(birth_year, birth_month, birth_day, Date.today.year, Date.today.month, Date.today.day)
    end
  end

  def birth_text
    if birth_year && birth_month && birth_day
      "#{I18n.t('people.birthday')}: #{I18n.l(Date.new(birth_year, birth_month, birth_day), format: :long)}"
    elsif birth_year && birth_month
      "#{I18n.t('people.birthday')}: #{I18n.l(Date.new(birth_year, birth_month, Date.today.day), format: :month_year_long)}"
    elsif birth_year
      "#{I18n.t('people.birthday')}: #{I18n.l(Date.new(birth_year, Date.today.month, Date.today.day), format: :year)}"
    elsif birth_month && birth_day
      "#{I18n.t('people.birthday')}: #{I18n.l(Date.new(Date.today.year, birth_month, birth_day), format: :day_month_long)}"
    end
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
    %w[alive birth birth_year birth_month birth_day death description gender name kanji]
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

  def formatted_long_date(year, month, day)
    if year && month && day
      I18n.l(Date.new(year, month, day), format: :long)
    elsif month && year
      I18n.l(Date.new(year, month, Date.today.day), format: :month_year_long)
    elsif day && month
      I18n.l(Date.new(Date.today.year, month, day), format: :day_month_long)
    elsif year
      I18n.l(Date.new(year, Date.today.month, Date.today.day), format: :year)
    end
  end

  def formatted_age(from_year, from_month, from_day, to_year, to_month, to_day)
    from_date = Date.new(from_year, from_month || 1, from_day || 1)
    to_date = Date.new(to_year, to_month || 1, to_day || 1)
    from_date, to_date = [from_date, to_date].sort
    years = to_date.year - from_date.year
    months = to_date.month - from_date.month
    days = to_date.day - from_date.day
    if days < 0
      months -= 1
      days += (to_date - 1.month).end_of_month.day
    end
    if months < 0
      years -= 1
      months += 12
    end
    if years > 0
      I18n.t('datetime.distance_in_words.x_years_old', count: years)
    elsif months > 0
      I18n.t('datetime.distance_in_words.x_months', count: months)
    else
      I18n.t('datetime.distance_in_words.x_days', count: days)
    end
  end
end
