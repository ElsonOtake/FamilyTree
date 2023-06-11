class Person < ApplicationRecord
  has_and_belongs_to_many :couples
  
  extend FriendlyId
  friendly_id :name, use: :slugged

  enum gender: [:M, :F, :P, :X]
end
