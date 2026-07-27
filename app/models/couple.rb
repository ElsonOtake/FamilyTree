# frozen_string_literal: true

# A couple is a pair of people. The order of the people is important, person1_id must be less than person2_id. This way is possible to avoid duplicates.
class Couple < ApplicationRecord
  include GenerateCsv
  include RecordEvent

  acts_as_paranoid

  # Relationship with children through the Child model
  has_many :child_relationships, class_name: 'Child', dependent: :destroy
  has_many :people, through: :child_relationships, source: :person

  belongs_to :person1, class_name: 'Person', foreign_key: 'person1_id'
  belongs_to :person2, class_name: 'Person', foreign_key: 'person2_id'

  before_save :order_people

  validates :person1_id, :person2_id, presence: true

  def order_people
    self.person1_id, self.person2_id = person2_id, person1_id if person1_id > person2_id
  end

  # This year's wedding anniversary (the marriage month/day in the current
  # year), or nil when no marriage date is recorded.
  def anniversary_this_year
    return nil unless marriage

    Date.new(Date.current.year, marriage.month, marriage.day)
  rescue Date::Error
    nil
  end

  # Whole days until this year's anniversary (negative if it already passed).
  def days_until_anniversary
    anniversary = anniversary_this_year
    return nil unless anniversary

    (anniversary - Date.current).to_i
  end

  # The anniversary number celebrated on this year's anniversary (e.g. 25 for a
  # couple married in 2000, queried in 2025). Nil when no marriage date.
  def anniversary_years
    return nil unless marriage

    Date.current.year - marriage.year
  end

  # Couples whose recurring wedding anniversary (year-agnostic month/day of the
  # marriage date) falls within [start_date, end_date] inclusive, ordered by how
  # soon it occurs. Handles ranges that cross a year boundary.
  def self.anniversaries_between(start_date, end_date)
    current_year = Date.current.year
    month = 'EXTRACT(MONTH FROM marriage)::int'
    day = 'EXTRACT(DAY FROM marriage)::int'
    scope = where.not(marriage: nil)

    scope = if start_date.year == end_date.year
              scope.where("MAKE_DATE(?, #{month}, #{day}) BETWEEN ? AND ?",
                          start_date.year, start_date, end_date)
            else
              scope.where(
                "MAKE_DATE(?, #{month}, #{day}) >= ? OR MAKE_DATE(?, #{month}, #{day}) <= ?",
                start_date.year, start_date, end_date.year, end_date
              )
            end

    scope
      .select("couples.*, (MAKE_DATE(#{current_year}, #{month}, #{day}) - CURRENT_DATE) AS days_until_anniversary")
      .order('days_until_anniversary ASC')
  end

  # Couples with a wedding anniversary in the given calendar month (1-12).
  def self.anniversaries_in_month(month)
    where.not(marriage: nil)
         .where('EXTRACT(MONTH FROM marriage) = ?', month)
         .order(Arel.sql('EXTRACT(DAY FROM marriage)'))
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

    # Use already loaded associations; compact drops a soft-deleted mate (the
    # belongs_to returns nil under the paranoia scope) so callers don't deref nil.
    couples.map { |couple| couple.person1_id != person_id ? couple.person1 : couple.person2 }.compact
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
