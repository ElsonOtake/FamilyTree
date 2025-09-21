class AddBirthdayIndexToPeople < ActiveRecord::Migration[8.0]
  def change
    add_index :people, [:birth_month, :birth_day], name: 'idx_people_birth_month_day'
  end
end
