# frozen_string_literal: true

require 'csv'

unless Person.any?
  csv_text = File.read(Rails.root.join('lib', 'seeds', 'people-2025-02-22.csv'))
  csv = CSV.parse(csv_text, headers: true, col_sep: ';')
  csv.each do |row|
    puts row['name'] if Rails.env.development?
    person = Person.new
    person.previous_id = row['id']
    person.name = row['name']
    person.kanji = row['kanji']
    person.gender = row['gender']
    person.alive = row['alive']
    person.birth = row['birth']
    person.death = row['death']
    person.description = row['description']
    person.created_at = row['created_at']
    person.updated_at = row['updated_at']
    person.deleted_at = row['deleted_at']
    person.slug = row['slug']
    person.save!
  end
  photos = [
    'f1.jpg',
    'f10.jpg',
    'f100.jpg',
    'f101.jpg',
    'f103.jpg',
    'f104.jpg',
    'f105.jpg',
    'f106.jpg',
    'f107.jpg',
    'f108.jpg',
    'f11.jpg',
    'f117.jpg',
    'f118.jpg',
    'f119.jpg',
    'f12.jpg',
    'f120.jpg',
    'f121.jpg',
    'f13.jpg',
    'f131.jpg',
    'f132.jpg',
    'f133.jpg',
    'f134.jpg',
    'f135.jpg',
    'f14.jpg',
    'f142.jpg',
    'f146.jpg',
    'f147.jpg',
    'f149.jpg',
    'f15.jpg',
    'f151.jpg',
    'f152.jpg',
    'f153.jpg',
    'f154.jpg',
    'f155.jpg',
    'f156.jpg',
    'f157.jpg',
    'f16.jpg',
    'f162.jpg',
    'f164.jpg',
    'f165.jpg',
    'f167.jpg',
    'f169.jpg',
    'f17.jpg',
    'f177.jpg',
    'f178.jpg',
    'f18.jpg',
    'f180.jpg',
    'f181.jpg',
    'f185.jpg',
    'f19.jpg',
    'f191.jpg',
    'f192.jpg',
    'f193.jpg',
    'f194.jpg',
    'f195.jpg',
    'f2.jpg',
    'f20.jpg',
    'f202.jpg',
    'f207.jpg',
    'f209.jpg',
    'f21.jpg',
    'f215.jpg',
    'f218.jpg',
    'f219.jpg',
    'f22.jpg',
    'f220.jpg',
    'f223.jpg',
    'f224.jpg',
    'f23.jpg',
    'f235.jpg',
    'f24.jpg',
    'f25.jpg',
    'f254.jpg',
    'f26.jpg',
    'f27.jpg',
    'f272.jpg',
    'f273.jpg',
    'f274.jpg',
    'f275.jpg',
    'f276.jpg',
    'f28.jpg',
    'f280.jpg',
    'f282.jpg',
    'f283.jpg',
    'f284.jpg',
    'f289.jpg',
    'f29.jpg',
    'f3.jpg',
    'f30.jpg',
    'f315.jpg',
    'f316.jpg',
    'f317.jpg',
    'f318.jpg',
    'f32.jpg',
    'f322.jpg',
    'f326.jpg',
    'f327.jpg',
    'f328.jpg',
    'f329.jpg',
    'f330.jpg',
    'f331.jpg',
    'f332.jpg',
    'f333.jpg',
    'f334.jpg',
    'f335.jpg',
    'f336.jpg',
    'f339.jpg',
    'f34.jpg',
    'f341.jpg',
    'f344.jpg',
    'f345.jpg',
    'f346.jpg',
    'f35.jpg',
    'f351.jpg',
    'f36.jpg',
    'f37.jpg',
    'f38.jpg',
    'f385.jpg',
    'f386.jpg',
    'f387.jpg',
    'f388.jpg',
    'f389.jpg',
    'f390.jpg',
    'f391.jpg',
    'f393.jpg',
    'f394.jpg',
    'f399.jpg',
    'f4.jpg',
    'f400.jpg',
    'f401.jpg',
    'f403.jpg',
    'f404.jpg',
    'f413.jpg',
    'f415.jpg',
    'f416.jpg',
    'f418.jpg',
    'f419.jpg',
    'f42.jpg',
    'f420.jpg',
    'f421.jpg',
    'f422.jpg',
    'f424.jpg',
    'f425.jpg',
    'f43.jpg',
    'f434.jpg',
    'f435.jpg',
    'f436.jpg',
    'f439.jpg',
    'f44.jpg',
    'f445.jpg',
    'f446.jpg',
    'f447.jpg',
    'f45.jpg',
    'f453.jpg',
    'f457.jpg',
    'f46.jpg',
    'f461.jpg',
    'f462.jpg',
    'f466.jpg',
    'f47.jpg',
    'f475.jpg',
    'f48.jpg',
    'f480.jpg',
    'f488.jpg',
    'f49.jpg',
    'f5.jpg',
    'f500.jpg',
    'f509.jpg',
    'f51.jpg',
    'f52.jpg',
    'f524.jpg',
    'f525.jpg',
    'f530.jpg',
    'f532.jpg',
    'f533.jpg',
    'f54.jpg',
    'f542.jpg',
    'f543.jpg',
    'f544.jpg',
    'f551.jpg',
    'f558.jpg',
    'f56.jpg',
    'f57.jpg',
    'f572.jpg',
    'f576.jpg',
    'f577.jpg',
    'f583.jpg',
    'f590.jpg',
    'f595.jpg',
    'f597.jpg',
    'f599.jpg',
    'f6.jpg',
    'f60.jpg',
    'f602.jpg',
    'f61.jpg',
    'f615.jpg',
    'f616.jpg',
    'f618.jpg',
    'f62.jpg',
    'f624.jpg',
    'f626.jpg',
    'f63.jpg',
    'f635.jpg',
    'f637.jpg',
    'f64.jpg',
    'f640.jpg',
    'f65.jpg',
    'f654.jpg',
    'f658.jpg',
    'f66.jpg',
    'f664.jpg',
    'f665.jpg',
    'f67.jpg',
    'f675.jpg',
    'f676.jpg',
    'f677.jpg',
    'f678.jpg',
    'f68.jpg',
    'f680.jpg',
    'f681.jpg',
    'f682.jpg',
    'f684.jpg',
    'f685.jpg',
    'f686.jpg',
    'f688.jpg',
    'f689.jpg',
    'f69.jpg',
    'f690.jpg',
    'f695.jpg',
    'f696.jpg',
    'f697.jpg',
    'f698.jpg',
    'f7.jpg',
    'f70.jpg',
    'f701.jpg',
    'f703.jpg',
    'f71.jpg',
    'f713.jpg',
    'f714.jpg',
    'f715.jpg',
    'f717.jpg',
    'f718.jpg',
    'f72.jpg',
    'f720.jpg',
    'f73.jpg',
    'f732.jpg',
    'f733.jpg',
    'f734.jpg',
    'f735.jpg',
    'f736.jpg',
    'f74.jpg',
    'f75.jpg',
    'f757.jpg',
    'f76.jpg',
    'f77.jpg',
    'f78.jpg',
    'f783.jpg',
    'f788.jpg',
    'f79.jpg',
    'f796.jpg',
    'f8.jpg',
    'f80.jpg',
    'f801.jpg',
    'f802.jpg',
    'f803.jpg',
    'f804.jpg',
    'f805.jpg',
    'f806.jpg',
    'f807.jpg',
    'f81.jpg',
    'f810.jpg',
    'f811.jpg',
    'f83.jpg',
    'f844.jpg',
    'f845.jpg',
    'f851.jpg',
    'f853.jpg',
    'f854.jpg',
    'f855.jpg',
    'f856.jpg',
    'f864.jpg',
    'f865.jpg',
    'f872.jpg',
    'f873.jpg',
    'f874.jpg',
    'f875.jpg',
    'f877.jpg',
    'f878.jpg',
    'f879.jpg',
    'f884.jpg',
    'f896.jpg',
    'f9.jpg',
    'f902.jpg',
    'f904.jpg',
    'f908.jpg',
    'f909.jpg',
    'f910.jpg',
    'f914.jpg',
    'f916.jpg',
    'f917.jpg',
    'f925.jpg',
    'f930.jpg',
    'f98.jpg',
    'f99.jpg'
  ]

  photos.each do |photo|
    person = Person.find_by(previous_id: photo[1..-5].to_i)
    person.avatar.attach(io: File.open(Rails.root.join("app/assets/images/photos/#{photo}")), filename: photo,
                         content_type: 'image/jpg')
    person.save!
  end
end

unless Couple.any?
  csv_text = File.read(Rails.root.join('lib', 'seeds', 'couples-2025-02-22.csv'))
  csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1', col_sep: ';')
  csv.each do |row|
    couple = Couple.new
    puts row['id'] if Rails.env.development?
    couple.previous_id = row['id']
    couple.person1_id = Person.find_by(previous_id: row['person1_id']).id
    couple.person2_id = Person.find_by(previous_id: row['person2_id']).id
    couple.marriage = row['marriage']
    couple.separation = row['separation']
    couple.local = row['local']
    couple.created_at = row['created_at']
    couple.updated_at = row['updated_at']
    couple.deleted_at = row['deleted_at']
    couple.save
  end
  csv_text = File.read(Rails.root.join('lib', 'seeds', 'children-2025-02-22.csv'))
  csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1', col_sep: ';')
  csv.each do |row|
    couple = Couple.find_by(previous_id: row['couple_id'])
    couple.people << Person.find_by(previous_id: row['person_id'])
    couple.save
  end
end

unless Role.any?
  csv_text = File.read(Rails.root.join('lib', 'seeds', 'roles-2025-02-22.csv'))
  csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1', col_sep: ';')
  csv.each do |row|
    puts row['name'] if Rails.env.development?
    role = Role.new
    role.name = row['name']
    role.resource_type = row['resource_type']
    role.resource_id = row['resource_id']
    role.created_at = row['created_at']
    role.updated_at = row['updated_at']
    role.deleted_at = row['deleted_at']
    role.save
  end
end

unless User.any?
  csv_text = File.read(Rails.root.join('lib', 'seeds', 'users-2025-02-22.csv'))
  csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1', col_sep: ';')
  csv.each do |row|
    puts row['email'] if Rails.env.development?
    user = User.new
    user.email = row['email']
    user.remember_created_at = row['remember_created_at']
    user.password = row['email'] == 'elsonotake@gmail.com' ? 'foobar' : '123456'
    user.name = row['name']
    user.phone = row['phone']
    user.locale = row['locale']
    user.confirmation_token = row['confirmation_token']
    user.confirmed_at = row['confirmed_at']
    user.confirmation_sent_at = row['confirmation_sent_at']
    user.unconfirmed_email = row['unconfirmed_email']
    user.created_at = row['created_at']
    user.updated_at = row['updated_at']
    user.deleted_at = row['deleted_at']
    user.save!
  end
end

user = User.find_by(email: 'elsonotake@gmail.com')
user.add_role :admin
