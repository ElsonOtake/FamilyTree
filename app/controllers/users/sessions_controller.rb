# frozen_string_literal: true

# This controller manages the sessions of the users.
# It inherits from Devise::SessionsController to handle user authentication.
# It also includes the Pundit authorization module to manage user permissions.
# The controller is responsible for creating and destroying user sessions.
# It also records login and logout events for auditing purposes.
module Users
  class SessionsController < Devise::SessionsController
    def create
      super do |user|
        # Registrar evento de login
        puts "**************************************** SessionsController create user_id: #{user.id} ip_address: #{request.remote_ip} user_agent: #{request.user_agent}"
        # Event.create(
        #   user_id: user.id,
        #   action: 'login',
        #   ip_address: request.remote_ip,
        #   user_agent: request.user_agent
        # )
      end
    end

    def destroy
      # Registrar evento de logout
      # Event.create(
      #   user_id: current_user.id,
      #   action: 'logout',
      #   ip_address: request.remote_ip,
      #   user_agent: request.user_agent
      # )
      puts "**************************************** SessionsController destroy user_id: #{current_user.id} ip_address: #{request.remote_ip} user_agent: #{request.user_agent}"

      super
    end
  end
end