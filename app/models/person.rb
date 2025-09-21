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
  has_many :favorites, dependent: :destroy
  has_many :favorited_by, through: :favorites, source: :user

  validates :name, presence: true
  validates :avatar, content_type: ['image/png', 'image/jpeg'],
                     size: { less_than: 1.megabytes, message: I18n.t('errors.messages.image_size') }
  validate :validate_birth_date
  validate :validate_death_date

  extend FriendlyId
  friendly_id :slug_candidates, use: %i[slugged finders history]

  enum :gender, %i[M F P X]

  scope :without_recorded_parents, -> { where.missing(:couples) }
  scope :with_birthdays_in_period, -> {
    where("birth_month IS NOT NULL AND birth_day IS NOT NULL")
  }

  before_validation :set_default_gender, on: :create

  def siblings
    # Find couples where this person is a child
    parent_couples = couples
    return [] if parent_couples.empty?

    # Get all children of those parent couples, excluding self
    parent_couples.flat_map(&:people).uniq - [self]
  end

  def father
    return nil if couples.empty?

    couple = couples.first
    # Use already loaded associations instead of find
    person1 = couple.person1
    person1.gender == 'M' ? person1 : couple.person2
  end

  def mother
    return nil if couples.empty?

    couple = couples.first
    # Use already loaded associations instead of find
    person1 = couple.person1
    person1.gender != 'M' ? person1 : couple.person2
  end

  def mate(couple_id)
    return nil if couple_id.nil?

    couple = Couple.includes(:person1, :person2).find_by(id: couple_id)
    return nil if couple.nil?

    # Use already loaded associations
    couple.person1_id == id ? couple.person2 : couple.person1
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

  def birthday_this_year
    return nil unless birth_month && birth_day
    Date.new(Date.current.year, birth_month, birth_day)
  rescue Date::Error
    nil
  end

  def birthday_next_year
    return nil unless birth_month && birth_day
    Date.new(Date.current.year + 1, birth_month, birth_day)
  rescue Date::Error
    nil
  end

  def days_until_birthday
    return nil unless birth_month && birth_day
    
    this_year = birthday_this_year
    today = Date.current
    
    return nil unless this_year
    
    (this_year - today).to_i
  end

  def alive?
    death_year.blank?
  end

  def age_on_birthday
    return nil unless birth_year && birth_month && birth_day && alive?
    
    birthday = birthday_this_year
    return nil unless birthday
    
    if birthday >= Date.current
      Date.current.year - birth_year
    else
      Date.current.year - birth_year + 1
    end
  end

  def self.upcoming_birthdays(days_ahead = 7, days_back = 7)
    start_date, end_date = birthday_date_range(days_ahead, days_back)
    
    # Get all people with complete birthday data
    people = with_birthdays_in_period.includes(:avatar_attachment)
    
    # Filter by actual birthday dates and sort
    people.select do |person|
      birthday = person.birthday_this_year
      next unless birthday
      birthday >= start_date && birthday <= end_date
    end.sort_by(&:days_until_birthday)
  end

  def self.upcoming_birthdays_for_people(people_collection, days_ahead = 7, days_back = 7)
    start_date, end_date = birthday_date_range(days_ahead, days_back)
    
    # Use the same optimized filtering as the main upcoming_birthdays method
    # Get people with complete birthday data from the provided collection
    people_with_birthdays = people_collection
                            .joins("LEFT JOIN active_storage_attachments ON active_storage_attachments.record_id = people.id AND active_storage_attachments.record_type = 'Person' AND active_storage_attachments.name = 'avatar'")
                            .where("birth_month IS NOT NULL AND birth_day IS NOT NULL")
                            .includes(:avatar_attachment)
    
    # Apply date filtering with SQL where possible
    # For most cases (within same year), we can filter efficiently
    if start_date.year == end_date.year && start_date.month <= end_date.month
      # Simple case: same year and no month wrap-around
      people_with_birthdays = people_with_birthdays.where(
        "(birth_month > ? OR (birth_month = ? AND birth_day >= ?)) AND (birth_month < ? OR (birth_month = ? AND birth_day <= ?))",
        start_date.month - 1, start_date.month, start_date.day,
        end_date.month + 1, end_date.month, end_date.day
      )
      
      # Final filtering and sorting in Ruby for exact date calculations
      people_with_birthdays.to_a.select do |person|
        birthday = person.birthday_this_year
        next unless birthday
        birthday >= start_date && birthday <= end_date
      end.sort_by(&:days_until_birthday)
    else
      # Complex case: year boundary or month wrap-around, fall back to Ruby filtering
      # Still more efficient than original as we pre-filter by birth_month/birth_day existence
      people_with_birthdays.to_a.select do |person|
        birthday = person.birthday_this_year
        next unless birthday
        birthday >= start_date && birthday <= end_date
      end.sort_by(&:days_until_birthday)
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[alive birth birth_year birth_month birth_day death description gender name kanji]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def self.birthday_date_range(days_ahead, days_back)
    today = Date.current
    [today - days_back.days, today + days_ahead.days]
  end

  def set_default_gender
    self.gender ||= 'M'
  end

  def validate_birth_date
    if birth_year.present? || birth_month.present? || birth_day.present?
      unless valid_partial_date?(birth_year, birth_month, birth_day)
        errors.add(:birth_date, I18n.t('errors.messages.invalid_partial_date'))
      end
    end
  end

  def validate_death_date
    if death_year.present? || death_month.present? || death_day.present?
      unless valid_partial_date?(death_year, death_month, death_day)
        errors.add(:death_date, I18n.t('errors.messages.invalid_partial_date'))
      end
    end
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

  def valid_partial_date?(year, month, day)
    # Check if year is valid
    return false if year.present? && year.to_i > Date.today.year

    # Check if month is valid
    return false if month.present? && (month.to_i < 1 || month.to_i > 12)

    # Check if day is valid
    if day.present?
      return true if year.present? && month.present? && Date.valid_date?(year.to_i, month.to_i, day.to_i)
      return false if day.to_i < 1 || day.to_i > 31
      return false if month.present? && day.to_i == 31 && [2, 4, 6, 9, 11].include?(month.to_i)
      return false if month.present? && day.to_i > 28 && month.to_i == 2
    end

    true
  end
end
