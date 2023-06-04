class FamilyMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.family_mailer.person_created.subject
  #
  def person_created
    @user = params[:user]
    @person = params[:person]

    mail to: "eaorigami@gmail.com", subject: "Person created (#{@person.id}) #{@person.name} by #{@user.name}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.family_mailer.person_updated.subject
  #
  def person_updated
    @user = params[:user]
    @person = params[:person]

    mail to: "eaorigami@gmail.com", subject: "Person updated (#{@person.id}) #{@person.name} by #{@user.name}"
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

    mail to: "eaorigami@gmail.com", subject: "Couple created (#{@couple.id}) #{@person_1_name} & #{@person_2_name} by #{@user.name}"
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

    mail to: "eaorigami@gmail.com", subject: "Couple updated (#{@couple.id}) #{@person_1_name} & #{@person_2_name} by #{@user.name}"
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

    mail to: "eaorigami@gmail.com", subject: "Child created: #{@child.name} (#{@child.id}) by #{@user.name}"
  end
end
