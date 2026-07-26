# frozen_string_literal: true

class AddTreeSettingsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :tree_generations, :integer, default: 5, null: false
    add_column :users, :include_pets_in_tree, :boolean, default: false, null: false
  end
end
