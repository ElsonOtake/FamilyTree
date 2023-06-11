class Person < ApplicationRecord
  has_and_belongs_to_many :couples
  validates :name, presence: true
  
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  enum gender: [:M, :F, :P, :X]
end
