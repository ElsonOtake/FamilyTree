# frozen_string_literal: true

# User model
class User < ApplicationRecord
  include GenerateCsv
  include ActiveModel::Dirty

  # acts_as_paranoid

  has_many :events
  has_many :favorites, dependent: :destroy
  has_many :favorite_people, through: :favorites, source: :person

  rolify
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :trackable, :omniauthable, omniauth_providers: [:google_oauth2]
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

  def omniauth_login?
    provider.present?
  end

  def self.from_omniauth(access_token)
    User.where(email: access_token.info.email).first || User.create(name: access_token.info.name,
                                                                    email: access_token.info.email,
                                                                    password: Devise.friendly_token[0, 20],
                                                                    provider: access_token.provider,
                                                                    confirmed_at: Time.current)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["confirmation_sent_at", "confirmation_token", "confirmed_at", "created_at", "deleted_at", "email", "encrypted_password", "id", "locale", "name", "phone", "provider", "remember_created_at", "reset_password_sent_at", "reset_password_token", "unconfirmed_email", "updated_at"]
  end
end
