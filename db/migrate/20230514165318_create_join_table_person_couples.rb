class CreateJoinTablePersonCouples < ActiveRecord::Migration[7.0]
  def change
    create_join_table :people, :couples do |t|
      t.index :person_id
      t.index :couple_id
    end
  end
end
