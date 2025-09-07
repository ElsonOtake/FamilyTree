# frozen_string_literal: true

require 'set'

# This controller manages pages in the family tree app.
class PagesController < ApplicationController
  before_action :authenticate_user!
  # before_action -> { authorize User }

  def about
  end

  def statistics
    @total_people = Person.count
    @people_by_gender = Person.group(:gender).count
    @living_people = Person.where(alive: true).count
    @deceased_people = Person.where(alive: false).count
    @unknown_status = Person.where(alive: nil).count
    
    @birth_year_stats = calculate_birth_year_stats
    @total_couples = Couple.count
    @people_without_parents = Person.without_recorded_parents.count
    @people_with_children = calculate_people_with_children
    @people_without_children = @total_people - @people_with_children
  end

  private

  def calculate_birth_year_stats
    decades = {}
    Person.where.not(birth_year: nil).pluck(:birth_year).each do |year|
      decade = (year / 10) * 10
      decades[decade] ||= 0
      decades[decade] += 1
    end
    decades.sort.to_h
  end

  def calculate_people_with_children
    people_with_children = Set.new
    Person.find_each do |person|
      children = person.children
      people_with_children.add(person.id) if children.any?
    end
    people_with_children.size
  end
end
