class FamilyMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.family_mailer.person_created.subject
  #
  def person_created
    @user = params[:user]
    @person = params[:person]

    mail to: "eaorigami@gmail.com", subject: "Created (#{@person.id}) #{@person.name} by #{@user.name}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.family_mailer.person_updated.subject
  #
  def person_updated
    @user = params[:user]
    @person = params[:person]

    mail to: "eaorigami@gmail.com", subject: "Updated (#{@person.id}) #{@person.name} by #{@user.name}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.family_mailer.couple_created.subject
  #
  def couple_created
    @greeting = "Hi"

    mail to: "eaorigami@gmail.com"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.family_mailer.couple_updated.subject
  #
  def couple_updated
    @greeting = "Hi"

    mail to: "eaorigami@gmail.com"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.family_mailer.child_created.subject
  #
  def child_created
    @greeting = "Hi"

    mail to: "eaorigami@gmail.com"
  end
end
