class AddPartialDatesToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :birth_day, :integer
    add_column :people, :birth_month, :integer
    add_column :people, :birth_year, :integer
    add_column :people, :death_day, :integer
    add_column :people, :death_month, :integer
    add_column :people, :death_year, :integer
  end
end
