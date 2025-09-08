class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :favorites, [:user_id, :person_id], unique: true
  end
end
