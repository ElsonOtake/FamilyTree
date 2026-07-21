class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@example.com"
  layout "mailer"

  # Embed the brand logo in every email so the shared layout header can render
  # it inline (referenced as attachments['logo.png'] in the mailer layout).
  before_action :attach_logo

  private

  def attach_logo
    attachments.inline["logo.png"] = File.read(Rails.root.join("app/assets/images/email_logo.png"))
  end
end
