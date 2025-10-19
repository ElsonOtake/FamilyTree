class AddCompositePrimaryKeyToCouplesPeople < ActiveRecord::Migration[8.0]
  def up
    # Add composite primary key constraint to couples_people table
    execute <<-SQL
      ALTER TABLE couples_people
      ADD CONSTRAINT couples_people_pkey
      PRIMARY KEY (person_id, couple_id);
    SQL
  end

  def down
    # Remove the composite primary key constraint
    execute <<-SQL
      ALTER TABLE couples_people
      DROP CONSTRAINT couples_people_pkey;
    SQL
  end
end
