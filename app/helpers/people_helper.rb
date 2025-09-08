# frozen_string_literal: true

# PeopleHelper
module PeopleHelper
  include Pagy::Frontend

  def age(from, to)
    return unless to > from

    days = (to - from).to_i
    if days / 365.25 > 1
      t('datetime.distance_in_words.x_years_old', count: (days / 365.25).to_i)
    elsif days / 30.6 > 1
      t('datetime.distance_in_words.x_months', count: (days / 30.6).to_i)
    else
      t('datetime.distance_in_words.x_days', count: days)
    end
  end

  def gender_color_class(gender)
    case gender
    when 'M'
      'has-text-info'
    when 'F'
      'has-text-danger'
    when 'P'
      'has-text-warning'
    when 'X'
      'has-text-success'
    when nil
      'has-text-grey'
    else
      'has-text-grey'
    end
  end

  def gender_icon_class(gender)
    case gender
    when 'M'
      'fas fa-mars'
    when 'F'
      'fas fa-venus'
    when 'P'
      'fas fa-venus-mars'
    when 'X'
      'fas fa-genderless'
    when nil
      'fas fa-question'
    else
      'fas fa-question'
    end
  end

  def gender_progress_class(gender)
    case gender
    when 'M'
      'is-info'
    when 'F'
      'is-danger'
    when 'P'
      'is-warning'
    when 'X'
      'is-success'
    when nil
      'is-grey'
    else
      'is-grey'
    end
  end
end
