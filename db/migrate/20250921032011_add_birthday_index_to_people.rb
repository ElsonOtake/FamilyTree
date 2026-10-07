# frozen_string_literal: true

class AddBirthdayIndexToPeople < ActiveRecord::Migration[8.0]
  def change
    add_index :people, %i[birth_month birth_day], name: 'idx_people_birth_month_day'
  end
end
