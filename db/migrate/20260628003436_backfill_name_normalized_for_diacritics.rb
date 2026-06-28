# frozen_string_literal: true

# Recompute name_normalized for every person now that RomajiNormalizer strips
# diacritics, so accented stored names (e.g. "Antônio") become searchable by
# their plain form. Idempotent: re-normalizing an already-plain name is a no-op.
class BackfillNameNormalizedForDiacritics < ActiveRecord::Migration[8.0]
  def up
    Person.reset_column_information
    Person.with_deleted.find_each do |person|
      normalized = RomajiNormalizer.normalize(person.name)
      person.update_column(:name_normalized, normalized) if person.name_normalized != normalized
    end
  end

  def down
    # No-op: the column already existed; this only refreshes its values.
  end
end
