class FamilyMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.family_mailer.person_created.subject
  #
  def person_created
    @user = params[:user]
    @person = params[:person]

    mail to: "no-reply@example.com", subject: "Person created: #{@person.name} (#{@person.id}) by #{@user.name}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.family_mailer.person_updated.subject
  #
  def person_updated
    @user = params[:user]
    @person = params[:person]

    mail to: "no-reply@example.com", subject: "Person updated: #{@person.name} (#{@person.id}) by #{@user.name}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.family_mailer.couple_created.subject
  #
  def couple_created
    @user = params[:user]
    @couple = params[:couple]
    @person_1_name = Person.find(@couple.person1_id).name
    @person_2_name = Person.find(@couple.person2_id).name

    mail to: "no-reply@example.com", subject: "Couple created: #{@person_1_name} & #{@person_2_name} (#{@couple.id}) by #{@user.name}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.family_mailer.couple_updated.subject
  #
  def couple_updated
    @user = params[:user]
    @couple = params[:couple]
    @person_1_name = Person.find(@couple.person1_id).name
    @person_2_name = Person.find(@couple.person2_id).name

    mail to: "no-reply@example.com", subject: "Couple updated: #{@person_1_name} & #{@person_2_name} (#{@couple.id}) by #{@user.name}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.family_mailer.child_created.subject
  #
  def child_created
    @user = params[:user]
    @child = params[:child]
    @couple = params[:couple]
    @person_1_name = Person.find(@couple.person1_id).name
    @person_2_name = Person.find(@couple.person2_id).name

    mail to: "no-reply@example.com", subject: "Child created: #{@child.name} (#{@child.id}) by #{@user.name}"
  end
end
