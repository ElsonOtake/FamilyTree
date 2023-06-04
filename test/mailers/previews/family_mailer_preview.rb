# Preview all emails at http://localhost:3000/rails/mailers/family_mailer
class FamilyMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/family_mailer/person_created
  def person_created
    FamilyMailer.person_created
  end

  # Preview this email at http://localhost:3000/rails/mailers/family_mailer/person_updated
  def person_updated
    FamilyMailer.with(user: User.last, person: Person.last).person_updated
  end

  # Preview this email at http://localhost:3000/rails/mailers/family_mailer/couple_created
  def couple_created
    FamilyMailer.couple_created
  end

  # Preview this email at http://localhost:3000/rails/mailers/family_mailer/couple_updated
  def couple_updated
    FamilyMailer.couple_updated
  end

  # Preview this email at http://localhost:3000/rails/mailers/family_mailer/child_created
  def child_created
    FamilyMailer.child_created
  end

end
