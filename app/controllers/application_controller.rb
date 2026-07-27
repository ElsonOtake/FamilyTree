# frozen_string_literal: true

# This is the main controller for the application.
class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_user
  around_action :switch_locale

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def switch_locale(&action)
    locale = current_user.try(:locale) || session[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def authenticate_admin_user!
    unless user_signed_in? && current_user.has_role?(:admin)
      flash[:alert] = I18n.t('active_admin.access_denied')
      redirect_to root_path # Redirect to home page or another page
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name phone])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name phone])
  end

  private

  # Expose the acting user request-wide so model callbacks that run outside a
  # controller's reach (e.g. Child events fired by dependent: :destroy cascades)
  # can attribute events to them instead of falling back to the system user.
  def set_current_user
    Current.user = current_user
  end

  def user_not_authorized
    flash[:alert] = t('errors.messages.unauthorized')
    redirect_back(fallback_location: root_path)
  end
end
