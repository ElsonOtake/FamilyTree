# frozen_string_literal: true

module Users
  # Users::RegistrationsController
  # This controller manages user registrations.
  # It inherits from Devise::RegistrationsController to handle user registration.
  # It also records events related to user creation, update, and deletion.
  class RegistrationsController < Devise::RegistrationsController
    def create
      super do |user|
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
  end
end
