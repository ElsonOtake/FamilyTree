# frozen_string_literal: true

# Adds a canonicalized copy of the name for romanization-tolerant search.
# See RomajiNormalizer for how variants like "Ohtake"/"Otake" are collapsed.
class AddNameNormalizedToPeople < ActiveRecord::Migration[8.0]
  def up
    add_column :people, :name_normalized, :string
    add_index :people, :name_normalized

    Person.reset_column_information
    # Backfill every record (including soft-deleted) so the column is populated
    # if a person is later restored. update_column skips validations/callbacks.
    Person.with_deleted.find_each do |person|
      person.update_column(:name_normalized, RomajiNormalizer.normalize(person.name))
    end
  end

  def down
    remove_column :people, :name_normalized
  end
end
