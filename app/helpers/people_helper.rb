module PeopleHelper
  include Pagy::Frontend

  def age(from, to)
    if to > from
      days = (to - from).to_i
      if days / 365.25 > 1
        t('datetime.distance_in_words.x_years_old', count: (days / 365.25).to_i)
      elsif days / 30.6 > 1
        t('datetime.distance_in_words.x_months', count: (days / 30.6).to_i)
      else
        t('datetime.distance_in_words.x_days', count: days)
      end
    end
  end
end
