# frozen_string_literal: true

# Users::RegistrationsController
module Users
  # This controller manages user registrations.
  # It inherits from Devise::RegistrationsController to handle user registration.
  # It also records events related to user creation, update, and deletion.
  class RegistrationsController < Devise::RegistrationsController
    include DemoMode

    def create
      super do |user|
        user.update_role!('admin') if demo_mode?
        user.events.create(
          name: 'user.create',
          data: user.saved_changes
        )
      end
    end

    def update
      super do |user|
        user.events.create(
          name: 'user.update',
          data: user.saved_changes
        )
      end
    end

    def destroy
      current_user.events.create(
        name: 'user.cancel',
        data: { email: resource.email, name: resource.name }
      )

      super
    end

    protected

    def build_resource(hash = {})
      super
      return unless demo_mode?

      resource.confirmed_at = Time.current
      resource.approved = true
    end
  end
end
