# frozen_string_literal: true

# With users now soft-deleted (acts_as_paranoid), a cancelled account keeps its
# row. A full unique index on email would then block anyone from ever registering
# that address again (and Devise's uniqueness validation, which runs inside the
# paranoia default scope, wouldn't even catch it — it would fail at the DB). Make
# the index partial so uniqueness only applies to live (non-deleted) users, which
# matches Devise's validation scope.
class MakeUsersEmailIndexParanoiaAware < ActiveRecord::Migration[7.0]
  def up
    remove_index :users, :email
    add_index :users, :email, unique: true, where: 'deleted_at IS NULL',
                              name: 'index_users_on_email'
  end

  def down
    remove_index :users, :email
    add_index :users, :email, unique: true, name: 'index_users_on_email'
  end
end
