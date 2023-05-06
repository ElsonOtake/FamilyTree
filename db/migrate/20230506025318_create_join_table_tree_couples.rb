class CreateJoinTableTreeCouples < ActiveRecord::Migration[7.0]
  def change
    create_join_table :trees, :couples do |t|
      t.index :tree_id
      t.index :couple_id
    end
  end
end
