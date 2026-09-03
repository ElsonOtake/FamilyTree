# frozen_string_literal: true

# User model
class User < ApplicationRecord
  include ActiveModel::Dirty
  extend DemoMode

  acts_as_paranoid

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
  validates :tree_generations,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :include_pets_in_tree, inclusion: { in: [true, false] }

  enum :locale, %i[pt en ja]

  def to_lowercase
    email.downcase!
  end

  # The access tiers, lowest to highest privilege. The single source of truth for
  # selectable roles (admin form, role management, validation).
  ROLES = %w[bronze silver gold admin].freeze

  def assign_default_role
    add_role(:bronze) if roles.blank?
  end

  # The user's single effective role (the highest one it holds), for display and
  # the admin form. Returns nil if the user has no recognized role.
  def role
    (roles.map(&:name) & ROLES).max_by { |name| ROLES.index(name) }
  end

  # Replace the user's roles with `name` and audit the change against `actor`.
  # Rejects any name outside ROLES, so a crafted param can't mint an arbitrary
  # role or strip access with a mis-cased value. Returns false on an invalid
  # name; true (without a redundant event) when already set.
  def update_role!(name, actor: nil)
    name = name.to_s
    return false unless ROLES.include?(name)
    return true if role == name

    old_roles = roles.pluck(:name)
    transaction do
      roles.delete_all
      add_role(name)
    end
    actor&.events&.create(name: 'role.update',
                          data: { user_id: id, old_roles: old_roles, new_roles: [name] })
    true
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
    user = User.find_or_create_by!(email: access_token.info.email) do |u|
      u.name = access_token.info.name
      u.password = Devise.friendly_token[0, 20]
      u.provider = access_token.provider
      u.confirmed_at = Time.current
      u.approved = demo_mode?
    end

    user.update_role!('admin') if user.previously_new_record? && demo_mode?

    user
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
