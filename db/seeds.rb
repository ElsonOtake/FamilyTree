# frozen_string_literal: true

# Seed data.
#
# This repository ships NO real personal data. `db:seed` ensures the app's roles
# exist and, in non-production environments, generates a small *fictional* family
# tree with Faker so the app can be run and demoed. Real data is loaded out of
# band (never committed) — see the gitignored lib/seeds/ directory.

# Roles used by rolify — safe to ensure in every environment.
%w[bronze silver gold admin].each { |name| Role.find_or_create_by!(name: name) }

# --- Bootstrap: ensure at least one admin exists, in ANY environment. ---
# Runs once — as soon as a single User exists, this is permanently skipped.
if User.any?
  Rails.logger.warn('Seeds: users already present — skipping bootstrap admin.')
else
  email    = ENV.fetch('SEED_ADMIN_EMAIL', 'admin@demo.com')
  password = ENV.fetch('SEED_ADMIN_PASSWORD', 'password' )

  admin = User.create!(
    email: email,
    password: password,
    name: ENV.fetch('SEED_ADMIN_NAME', 'Admin User'),
    confirmed_at: Time.current,
    approved: true,
    locale: 'en'
  )
  admin.add_role(:admin)

  Rails.logger.warn("Seeds: created admin #{email}.")
end

# --- Demo/fictional data ---
if Person.any?
  Rails.logger.warn('Seeds: people already present — skipping synthetic tree.')
else
  require 'faker'
  admin = User.find_by!(email: ENV.fetch('SEED_ADMIN_EMAIL', 'admin@demo.com'))
  Current.user = admin

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

  all_people = []

  # Generation 1 — two founding couples (grandparents), all deceased.
  gen2_parents = []
  2.times do
    grandpa = make_person.call('M', from: Date.new(1930, 1, 1), to: Date.new(1940, 12, 31), alive: false)
    grandma = make_person.call('F', from: Date.new(1933, 1, 1), to: Date.new(1943, 12, 31), alive: false)
    couple = make_couple.call(grandpa, grandma, from: Date.new(1955, 1, 1), to: Date.new(1962, 12, 31))
    all_people << grandpa << grandma

    # Generation 2 — their children.
    rand(2..3).times do
      child = make_person.call(%w[M F].sample, from: Date.new(1960, 1, 1), to: Date.new(1972, 12, 31))
      couple.people << child
      gen2_parents << child
      all_people << child
    end
  end

  # Generation 2 marriages + Generation 3 (grandchildren).
  gen2_parents.each do |parent|
    spouse_gender = parent.gender == 'M' ? 'F' : 'M'
    spouse = make_person.call(spouse_gender, from: Date.new(1962, 1, 1), to: Date.new(1974, 12, 31))
    couple = make_couple.call(parent, spouse, from: Date.new(1988, 1, 1), to: Date.new(1998, 12, 31))
    all_people << spouse

    rand(1..3).times do
      grandchild = make_person.call(%w[M F].sample, from: Date.new(1992, 1, 1), to: Date.new(2012, 12, 31))
      couple.people << grandchild
      all_people << grandchild
    end
  end

  # Flag a handful of people as the admin's favorites, so the demo has
  # something to show in that view out of the box.
  favorite_count = [6, all_people.size].min
  admin.favorite_people = all_people.sample(favorite_count)

  Current.user = nil
  Rails.logger.warn("Seeds: created #{Person.count} people, #{Couple.count} couples." \
                     "#{admin.favorites.count} favorites for #{admin.email}.")
end
