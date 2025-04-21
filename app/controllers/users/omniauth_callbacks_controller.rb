# frozen_string_literal: true

module Users
  # Users::OmniauthCallbacksController
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      handle_auth 'Google'
    end

    def handle_auth(auth)
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        @user.events.create(
          name: 'user.omniauth',
          data: { ip_address: request.remote_ip, user_agent: request.user_agent }
        )

        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: auth
        sign_in_and_redirect @user, event: :authentication
      else
        # session['devise.auth_data'] = request.env['omniauth.auth'].except('extra')
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
    end
  end
end
