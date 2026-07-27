# frozen_string_literal: true

class AddDeletedAtToCouplesPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :couples_people, :deleted_at, :datetime
    add_index :couples_people, :deleted_at
  end
end
