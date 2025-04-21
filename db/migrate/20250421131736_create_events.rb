class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true
      t.jsonb :data, null: false, default: {}
      t.datetime :created_at
    end
  end
end
