class CreateTrees < ActiveRecord::Migration[7.0]
  def change
    create_table :trees do |t|
      t.string :name
      t.integer :gender
      t.boolean :alive, default: true
      t.date :birth
      t.date :death
      t.text :description

      t.timestamps
    end
  end
end
