# frozen_string_literal: true

# This mailer manages the emails sent to the user.
class FamilyMailer < ApplicationMailer
  DEFAULT_EMAIL = 'no-reply@example.com'

  def person_created
    @user = params[:user]
    @person = params[:person]

    mail to: DEFAULT_EMAIL, subject: "Person created: #{@person.name} (#{@person.id}) by #{@user.name}"
  end

  def person_updated
    @user = params[:user]
    @person = params[:person]

    mail to: DEFAULT_EMAIL, subject: "Person updated: #{@person.name} (#{@person.id}) by #{@user.name}"
  end

  def couple_created
    @user = params[:user]
    @couple = params[:couple]
    @person_1_name = Person.find(@couple.person1_id).name
    @person_2_name = Person.find(@couple.person2_id).name

    mail to: DEFAULT_EMAIL, subject: "Couple created: #{@person_1_name} & #{@person_2_name} (#{@couple.id}) by #{@user.name}"
  end

  def couple_updated
    @user = params[:user]
    @couple = params[:couple]
    @person_1_name = Person.find(@couple.person1_id).name
    @person_2_name = Person.find(@couple.person2_id).name

    mail to: DEFAULT_EMAIL, subject: "Couple updated: #{@person_1_name} & #{@person_2_name} (#{@couple.id}) by #{@user.name}"
  end

  def couple_deleted
    @user = params[:user]
    @id = params[:id]
    @person_1_id = params[:person_1]
    @person_2_id = params[:person_2]
    @person_1_name = Person.find(params[:person_1]).name
    @person_2_name = Person.find(params[:person_2]).name
    @marriage = params[:marriage]
    @separation = params[:separation]
    @local = params[:local]

    mail to: DEFAULT_EMAIL, subject: "Couple deleted: #{@person_1_name} & #{@person_2_name} (#{@id}) by #{@user.name}"
  end

  def child_created
    @user = params[:user]
    @child = params[:child]
    @couple = params[:couple]
    @person_1_name = Person.find(@couple.person1_id).name
    @person_2_name = Person.find(@couple.person2_id).name

    mail to: DEFAULT_EMAIL, subject: "Child created: #{@child.name} (#{@child.id}) by #{@user.name}"
  end

  def child_deleted
    @user = params[:user]
    @child = params[:child]
    @couple = params[:couple]
    @person_1_name = Person.find(@couple.person1_id).name
    @person_2_name = Person.find(@couple.person2_id).name

    mail to: DEFAULT_EMAIL, subject: "Child deleted: #{@child.name} (#{@child.id}) by #{@user.name}"
  end
end
