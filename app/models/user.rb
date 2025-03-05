# frozen_string_literal: true

# User model
class User < ApplicationRecord
  include GenerateCsv

  # acts_as_paranoid

  rolify
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :trackable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]
  after_create :assign_default_role
  before_save :to_lowercase
  validates :name, presence: true

  enum locale: %i[pt en ja]

  def to_lowercase
    email.downcase!
  end

  def assign_default_role
    add_role(:bronze) if roles.blank?
  end

  def self.from_omniauth(access_token)
    User.where(email: access_token.info.email).first || User.create(name: access_token.info.name,
                                                                    email: access_token.info.email,
                                                                    password: Devise.friendly_token[0, 20])
  end
end
