# Preview all emails at http://localhost:3000/rails/mailers/mailer_mailer
class MailerMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/mailer_mailer/person_created
  def person_created
    MailerMailer.person_created
  end

  # Preview this email at http://localhost:3000/rails/mailers/mailer_mailer/person_updated
  def person_updated
    MailerMailer.person_updated
  end

  # Preview this email at http://localhost:3000/rails/mailers/mailer_mailer/couple_created
  def couple_created
    MailerMailer.couple_created
  end

  # Preview this email at http://localhost:3000/rails/mailers/mailer_mailer/couple_updated
  def couple_updated
    MailerMailer.couple_updated
  end

  # Preview this email at http://localhost:3000/rails/mailers/mailer_mailer/child_created
  def child_created
    MailerMailer.child_created
  end

end
