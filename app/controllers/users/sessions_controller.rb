# frozen_string_literal: true

module Users
  # This controller manages the sessions of the users.
  # It inherits from Devise::SessionsController to handle user authentication.
  # It also includes the Pundit authorization module to manage user permissions.
  # The controller is responsible for creating and destroying user sessions.
  # It also records login and logout events for auditing purposes.
  class SessionsController < Devise::SessionsController
    def create
      super do |user|
        user.events.create(
          name: 'user.login',
          data: { ip_address: request.remote_ip, user_agent: request.user_agent }
        )
      end
    end

    def destroy
      current_user.events.create(
        name: 'user.logout',
        data: { ip_address: request.remote_ip, user_agent: request.user_agent }
      )

      super
    end
  end
end
