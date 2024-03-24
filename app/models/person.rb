class Person < ApplicationRecord
  has_and_belongs_to_many :couples
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [240, 240]
  end
  
  validates :name, presence: true
  validates :avatar, content_type: ['image/png', 'image/jpeg'],
    size: { less_than: 1.megabytes , message: 'image is greater than 1 Megabyte' }

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders, :history]

  enum gender: [:M, :F, :P, :X]

  scope :without_recorded_parents, -> { where.missing(:couples) }

  def slug_candidates
    [
      :name,
      [:name, :description]
    ]
  end

  def should_generate_new_friendly_id?
    name_changed?
  end

  def self.ransackable_attributes(auth_object = nil)
    ["alive", "birth", "death", "description", "gender", "name"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
