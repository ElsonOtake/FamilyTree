class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, 
         :recoverable, :rememberable, :validatable
  after_create :assign_default_role
  before_save :to_lowercase
  validates :name, presence: true

  enum locale: [ :pt, :en, :ja ]

  def to_lowercase
    email.downcase!
  end

  def assign_default_role
    self.add_role(:bronze) if self.roles.blank?
  end
end
