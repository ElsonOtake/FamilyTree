# frozen_string_literal: true

# This model represents a user's favorite person in the family tree.
class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :person
  
  validates :user_id, uniqueness: { scope: :person_id, message: 'has already favorited this person' }
  validates :user, presence: true
  validates :person, presence: true
end
