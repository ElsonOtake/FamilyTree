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

  enum :locale, %i[pt en ja]

  def to_lowercase
    email.downcase!
  end

  def assign_default_role
    add_role(:bronze) if roles.blank?
  end

  def omniauth_login?
    provider.present?
  end

  # New users must be approved by an admin before they can sign in. This gates
  # sign-in on top of e-mail confirmation, and revoking approval signs the user
  # out on their next request.
  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    return super if respond_to?(:confirmed?) && !confirmed? # e-mail confirmation comes first

    approved? ? super : :not_approved
  end

  # Grant access and notify the user by e-mail. No-op if already approved.
  def approve!
    return false if approved?

    update!(approved: true)
    UserMailer.with(user: self).approved.deliver_later
    true
  end

  # Revoke access (they will be signed out on their next request).
  def unapprove!
    update!(approved: false)
  end

  # Whether this user has enabled access to the MCP server.
  def mcp_enabled?
    mcp_token.present?
  end

  # Generate (or rotate) the token used to authenticate this user against the
  # MCP server. Opt-in: tokens are not created automatically, so a user only
  # gains MCP access once they explicitly request a token.
  def regenerate_mcp_token!
    update!(mcp_token: self.class.generate_unique_secure_token(length: 32))
  end

  # Disable MCP access for this user by clearing the token.
  def revoke_mcp_token!
    update!(mcp_token: nil)
  end

  # Resolve a user from a bearer token. Returns nil for blank or unknown tokens.
  def self.find_by_mcp_token(token)
    return nil if token.blank?

    find_by(mcp_token: token)
  end

  def self.from_omniauth(access_token)
    User.where(email: access_token.info.email).first || User.create(name: access_token.info.name,
                                                                    email: access_token.info.email,
                                                                    password: Devise.friendly_token[0, 20],
                                                                    provider: access_token.provider,
                                                                    confirmed_at: Time.current)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[approved confirmation_sent_at confirmation_token confirmed_at created_at deleted_at email
       encrypted_password id locale name phone provider remember_created_at reset_password_sent_at
       reset_password_token unconfirmed_email updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[events favorite_people favorites roles]
  end

  # Get or create system user for automated operations
  def self.system_user
    find_or_create_by!(email: 'system@familytree.internal') do |user|
      user.name = 'System'
      user.password = SecureRandom.hex(32)
      user.confirmed_at = Time.current
      user.locale = :en
    end
  end
end
