class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, 
         :recoverable, :rememberable, :validatable
  before_save :to_lowercase
  validates :name, presence: true

  enum locale: [ :pt, :en, :ja ]

  def to_lowercase
    email.downcase!
  end
end
