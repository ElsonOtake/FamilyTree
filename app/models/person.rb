# frozen_string_literal: true

# This model represents a person in the family tree.
class Person < ApplicationRecord
  include RecordEvent

  acts_as_paranoid

  # Relationship with parent couples through the Child model
  has_many :parent_relationships, class_name: 'Child', foreign_key: 'person_id', dependent: :destroy
  has_many :couples, through: :parent_relationships, source: :couple

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

  # Let ransack (admin filters and search) match gender by its enum key ("F") as
  # well as by the stored integer, and surface the key rather than the raw
  # integer in filter summaries. Ransack casts a bare "F" to 0 via to_i, so this
  # formatter maps the key to its enum value; integers already in string/int form
  # pass through unchanged.
  ransacker :gender, formatter: proc { |value| Person.genders.fetch(value.to_s, value) } do |parent|
    parent.table[:gender]
  end

  scope :without_recorded_parents, -> { where.missing(:couples) }
  scope :with_birthdays_in_period, -> {
    where("birth_month IS NOT NULL AND birth_day IS NOT NULL")
  }

  before_validation :set_default_gender, on: :create
  before_save :set_name_normalized, if: :name_changed?

  # A pet is a person with the 'P' gender; tree exports can hide them.
  def pet?
    gender == 'P'
  end

  def siblings
    # Find couples where this person is a child
    parent_couples = couples
    return [] if parent_couples.empty?

    # Get all children of those parent couples, excluding self, oldest first.
    BirthOrder.sort(parent_couples.flat_map(&:people).uniq - [self])
  end

  def cousins
    # Parents are person1/person2 of this person's parent couples; compact drops
    # any soft-deleted parent (the belongs_to returns nil under the paranoia scope).
    parents = couples.flat_map { |couple| [couple.person1, couple.person2] }.compact.uniq
    return [] if parents.empty?

    # Aunts/uncles are the parents' siblings; first cousins are their children.
    aunts_and_uncles = parents.flat_map(&:siblings).uniq - parents
    aunts_and_uncles.flat_map(&:children).uniq - [self] - siblings
  end

  def father
    parent_pair.first
  end

  def mother
    parent_pair.last
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
    # Dead if a death year is recorded, or if explicitly marked not alive via
    # the `alive` flag (which can be set without a known death date). A nil flag
    # means "unknown" and is treated as alive. This guards age calculations from
    # reporting an implausible age for someone who is actually deceased.
    return false if death_year.present?

    self[:alive] != false
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
    filter_birthdays_in_range(all, days_ahead, days_back)
  end

  def self.upcoming_birthdays_for_people(people_collection, days_ahead = 7, days_back = 7)
    filter_birthdays_in_range(people_collection, days_ahead, days_back)
  end

  # People whose recurring birthday (year-agnostic month/day) falls within
  # [start_date, end_date] inclusive, ordered by how soon the birthday occurs.
  # Handles ranges that cross a year boundary (e.g. late Dec into early Jan).
  # Callable on a relation to scope the result (e.g. favorites.birthdays_between).
  def self.birthdays_between(start_date, end_date)
    current_year = Date.current.year
    scope = where("birth_month IS NOT NULL AND birth_day IS NOT NULL")

    scope = if start_date.year == end_date.year
              scope.where("MAKE_DATE(?, birth_month, birth_day) BETWEEN ? AND ?",
                          start_date.year, start_date, end_date)
            else
              scope.where(
                "MAKE_DATE(?, birth_month, birth_day) >= ? OR MAKE_DATE(?, birth_month, birth_day) <= ?",
                start_date.year, start_date, end_date.year, end_date
              )
            end

    scope
      .select("people.*, (MAKE_DATE(#{current_year}, birth_month, birth_day) - CURRENT_DATE) AS days_until_birthday")
      .order("days_until_birthday ASC")
  end

  # People with a birthday in the given calendar month (1-12), ordered by day.
  def self.birthdays_in_month(month)
    where(birth_month: month).where.not(birth_day: nil).order(:birth_day)
  end

  # Search people by name (or kanji). The query is split into words on
  # whitespace, hyphens and underscores, and every word must appear in the
  # romanization-normalized name or the raw kanji. Word order and skipped middle
  # names don't matter, so "elson otake" and "otake-elson" both match
  # "Elson Akio Otake".
  def self.search_by_name(query)
    tokens = query.to_s.split(/[\s_-]+/).reject(&:blank?)
    return none if tokens.empty?

    tokens.reduce(all) do |scope, token|
      normalized = sanitize_sql_like(RomajiNormalizer.normalize(token))
      kanji = sanitize_sql_like(token)
      scope.where('name_normalized LIKE :name OR kanji ILIKE :kanji',
                  name: "%#{normalized}%", kanji: "%#{kanji}%")
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id alive birth birth_year birth_month birth_day death description gender name kanji created_at updated_at deleted_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def self.birthday_date_range(days_ahead, days_back)
    today = Date.current
    [today - days_back.days, today + days_ahead.days]
  end

  def self.filter_birthdays_in_range(people_collection, days_ahead, days_back)
    start_date, end_date = birthday_date_range(days_ahead, days_back)
    # MAKE_DATE requires PostgreSQL 9.4+; avatar is eager-loaded for the view.
    people_collection.includes(:avatar_attachment).birthdays_between(start_date, end_date)
  end

  # [father, mother] for the first parent couple. A male parent is placed first
  # (father), the other second (mother), preserving the historic labelling. Soft-
  # deleted couple members return nil from the belongs_to (paranoia scope) and are
  # dropped, so a surviving parent is never duplicated across both slots and either
  # slot may be nil.
  def parent_pair
    return [nil, nil] if couples.empty?

    people = [couples.first.person1, couples.first.person2].compact
    male = people.find { |person| person.gender == 'M' }
    return [male, (people - [male]).first] if male

    [people.second, people.first]
  end

  def set_default_gender
    self.gender ||= 'M'
  end

  # Keep the canonicalized name in sync so search can match romanization
  # variants (e.g. "Ohtake"/"Otake"). See RomajiNormalizer.
  def set_name_normalized
    self.name_normalized = RomajiNormalizer.normalize(name)
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
