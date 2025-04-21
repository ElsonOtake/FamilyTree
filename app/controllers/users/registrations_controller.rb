# frozen_string_literal: true

# This controller manages the sessions of the users.
# It inherits from Devise::SessionsController to handle user authentication.
# It also includes the Pundit authorization module to manage user permissions.
# The controller is responsible for creating and destroying user sessions.
# It also records login and logout events for auditing purposes.
module Users
  class RegistrationsController < Devise::RegistrationsController
    def create
      super do |user|
        # Registrar evento de login
        puts "**************************************** RegistrationsController name: 'user.create' user_id: #{user.id} data: { changes: #{user.changes} saved_changes: #{user.saved_changes} }"
        # Event.create(
        #   user_id: user.id,
        #   action: 'login',
        #   ip_address: request.remote_ip,
        #   user_agent: request.user_agent
        # )
      end
    end

    def update
      super do |user|
        # Registrar evento de login
        puts "**************************************** RegistrationsController name: 'user.update' user_id: #{user.id} data: { saved_changes: #{user.saved_changes} }"
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
      puts "**************************************** RegistrationsController name: 'user.cancel' user_id: #{current_user.id} data: { email: #{resource.email}, name: #{resource.name} }"

      super
    end
  end
end
