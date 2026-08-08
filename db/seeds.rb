# frozen_string_literal: true

# Seed data.
#
# This repository ships NO real personal data. `db:seed` ensures the app's roles
# exist and, in non-production environments, generates a small *fictional* family
# tree with Faker so the app can be run and demoed. Real data is loaded out of
# band (never committed) — see the gitignored lib/seeds/ directory.

# Roles used by rolify — safe to ensure in every environment.
%w[bronze silver gold admin].each { |name| Role.find_or_create_by!(name: name) }

if Rails.env.production?
  Rails.logger.info('Seeds: production — skipping synthetic data (real data is loaded out of band).')
elsif Person.any?
  Rails.logger.info('Seeds: people already present — skipping synthetic tree.')
else
  require 'faker'

  # A demo login for exploring the app (idempotent).
  demo = User.find_by(email: 'demo@example.com') || User.create!(
    email: 'demo@example.com',
    password: 'password',
    name: 'Demo User',
    confirmed_at: Time.current,
    approved: true,
    locale: 'en'
  )
  demo.add_role(:admin) unless demo.has_role?(:admin)

  # Attribute the seeded records to the demo user so the audit trail is coherent
  # (and Child linking doesn't fall back to a system user).
  Current.user = demo

  make_person = lambda do |gender, from:, to:, alive: true|
    first = gender == 'M' ? Faker::Name.male_first_name : Faker::Name.female_first_name
    Person.create!(
      name: "#{first} #{Faker::Name.last_name}",
      gender: gender,
      alive: alive,
      birth: Faker::Date.between(from: from, to: to),
      description: Faker::Lorem.sentence
    )
  end

  make_couple = lambda do |p1, p2, from:, to:|
    Couple.create!(
      person1_id: [p1.id, p2.id].min,
      person2_id: [p1.id, p2.id].max,
      marriage: Faker::Date.between(from: from, to: to)
    )
  end

  # Generation 1 — two founding couples (grandparents), all deceased.
  gen2_parents = []
  2.times do
    grandpa = make_person.call('M', from: Date.new(1930, 1, 1), to: Date.new(1940, 12, 31), alive: false)
    grandma = make_person.call('F', from: Date.new(1933, 1, 1), to: Date.new(1943, 12, 31), alive: false)
    couple = make_couple.call(grandpa, grandma, from: Date.new(1955, 1, 1), to: Date.new(1962, 12, 31))

    # Generation 2 — their children.
    rand(2..3).times do
      child = make_person.call(%w[M F].sample, from: Date.new(1960, 1, 1), to: Date.new(1972, 12, 31))
      couple.people << child
      gen2_parents << child
    end
  end

  # Generation 2 marriages + Generation 3 (grandchildren).
  gen2_parents.each do |parent|
    spouse_gender = parent.gender == 'M' ? 'F' : 'M'
    spouse = make_person.call(spouse_gender, from: Date.new(1962, 1, 1), to: Date.new(1974, 12, 31))
    couple = make_couple.call(parent, spouse, from: Date.new(1988, 1, 1), to: Date.new(1998, 12, 31))

    rand(1..3).times do
      grandchild = make_person.call(%w[M F X].sample, from: Date.new(1992, 1, 1), to: Date.new(2012, 12, 31))
      couple.people << grandchild
    end
  end

  Current.user = nil
  Rails.logger.info("Seeds: created #{Person.count} people, #{Couple.count} couples.")
end
