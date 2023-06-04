# Preview all emails at http://localhost:3000/rails/mailers/family_mailer
class FamilyMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/family_mailer/person_created
  def person_created
    FamilyMailer.with(user: User.first, person: Person.first).person_created
  end

  # Preview this email at http://localhost:3000/rails/mailers/family_mailer/person_updated
  def person_updated
    FamilyMailer.with(user: User.first, person: Person.first).person_updated
  end

  # Preview this email at http://localhost:3000/rails/mailers/family_mailer/couple_created
  def couple_created
    FamilyMailer.with(user: User.first, couple: Couple.first).couple_created
  end

  # Preview this email at http://localhost:3000/rails/mailers/family_mailer/couple_updated
  def couple_updated
    FamilyMailer.with(user: User.first, couple: Couple.first).couple_updated
  end

  # Preview this email at http://localhost:3000/rails/mailers/family_mailer/child_created
  def child_created
    FamilyMailer.with(user: User.first, child: Person.first, couple: Couple.first).child_created
  end

end
