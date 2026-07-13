# frozen_string_literal: true

# Adds an admin-approval flag. New users default to unapproved; existing users
# are grandfathered in as approved so they keep their current access.
class AddApprovedToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :approved, :boolean, default: false, null: false
    add_index :users, :approved

    # Existing users keep access.
    User.reset_column_information
    User.update_all(approved: true)
  end

  def down
    remove_column :users, :approved
  end
end
