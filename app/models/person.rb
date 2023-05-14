class Person < ApplicationRecord
  has_and_belongs_to_many :couples

  enum gender: [:M, :F, :P, :X]
end
