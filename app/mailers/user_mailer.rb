# frozen_string_literal: true

# Account-related notifications to end users.
class UserMailer < ApplicationMailer
  # Sent when an admin approves a pending account.
  def approved
    @user = params[:user]
    I18n.with_locale(user_locale) do
      mail to: @user.email, subject: I18n.t('user_mailer.approved.subject')
    end
  end

  private

  def user_locale
    @user.locale.presence || I18n.default_locale
  end
end
