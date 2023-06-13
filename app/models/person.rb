class Person < ApplicationRecord
  has_and_belongs_to_many :couples
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [240, 240]
  end
  
  validates :name, presence: true
  
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders, :history]

  enum gender: [:M, :F, :P, :X]

  def slug_candidates
    [
      :name,
      [:name, :description]
    ]
  end

  def should_generate_new_friendly_id?
    name_changed?
  end
end
