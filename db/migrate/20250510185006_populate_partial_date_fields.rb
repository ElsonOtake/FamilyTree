class PopulatePartialDateFields < ActiveRecord::Migration[7.0]
  def up
    Person.find_each do |person|
      # Processar data de nascimento
      if person.birth.present?
        if person.birth.day == 1 && person.birth.month == 1
          person.update(
            birth_year: person.birth.year
          )
        else
          person.update_columns(
            birth_day: person.birth.day,
            birth_month: person.birth.month,
            birth_year: person.birth.year
          )
        end
      end

      # Processar data de falecimento
      if person.death.present?
        if person.death.day == 1 && person.death.month == 1
          person.update(
            death_year: person.death.year
          )
        else
          person.update_columns(
            death_day: person.death.day,
            death_month: person.death.month,
            death_year: person.death.year
          )
        end
      end
    end
  end

  def down
    # Reverter os valores para nil, caso necessário
    Person.update_all(birth_day: nil, birth_month: nil, birth_year: nil, death_day: nil, death_month: nil, death_year: nil)
  end
end
