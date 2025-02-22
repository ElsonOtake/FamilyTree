class AddDeletedAtToCouples < ActiveRecord::Migration[7.0]
  def change
    add_column :couples, :deleted_at, :datetime
    add_index :couples, :deleted_at
  end
end
