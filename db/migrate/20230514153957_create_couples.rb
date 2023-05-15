class CreateCouples < ActiveRecord::Migration[7.0]
  def change
    create_table :couples do |t|
      t.integer :person1_id
      t.integer :person2_id
      t.date :marriage
      t.date :separation
      t.text :local

      t.timestamps
    end
  end
end
