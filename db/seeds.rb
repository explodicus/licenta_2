user = User.new(first_name: 'Dan',
                last_name: 'Gutu',
                date_of_birth: Date.new(1997, 11, 29),
                phone_number: '061081027',
                preferred_language: 'Romanian',
                discount: 0.0,
                admin_confirmed: true,
                email: 'dan@example.com',
                password: 'qwerty',
                password_confirmation: 'qwerty')
user.skip_confirmation!
user.save!

user = User.new(first_name: 'Alexei',
                last_name: 'Gutu',
                date_of_birth: Date.new(1974, 4, 29),
                phone_number: '060442229',
                preferred_language: 'Romanian',
                discount: 0.0,
                admin_confirmed: true,
                email: 'alexei@example.com',
                password: 'qwerty',
                password_confirmation: 'qwerty')
user.skip_confirmation!
user.save!

user = User.new(first_name: 'Ala',
                last_name: 'Gutu',
                date_of_birth: Date.new(1975, 11, 14),
                phone_number: '060551555',
                preferred_language: 'Romanian',
                discount: 0.0,
                admin_confirmed: true,
                email: 'ala@example.com',
                password: 'qwerty',
                password_confirmation: 'qwerty')
user.skip_confirmation!
user.save!

user = User.new(first_name: 'Diana',
                last_name: 'Sapoval',
                date_of_birth: Date.new(1985, 1, 1),
                phone_number: '061081024',
                preferred_language: 'Romanian',
                discount: 0.0,
                admin_confirmed: true,
                email: 'diana@example.com',
                password: 'qwerty',
                password_confirmation: 'qwerty')
user.skip_confirmation!
user.save!

user = User.new(first_name: 'Veronica',
                last_name: 'Peev',
                date_of_birth: Date.new(1978, 1, 2),
                phone_number: '061081024',
                preferred_language: 'Romanian',
                discount: 0.0,
                admin_confirmed: true,
                email: 'veronica@example.com',
                password: 'qwerty',
                password_confirmation: 'qwerty')
user.skip_confirmation!
user.save!

95.times do |n|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  date_of_birth = Faker::Date.birthday(10, 65)
  phone_number = Faker::Number.leading_zero_number(9)
  email = "example-#{n+1}@example.com"
  password = 'password'
  user = User.new(first_name: first_name,
                  last_name: last_name,
                  date_of_birth: date_of_birth,
                  phone_number: phone_number,
                  preferred_language: 'English',
                  admin_confirmed: true,
                  email: email,
                  password: password,
                  password_confirmation: password)
  user.skip_confirmation!
  user.save!
end

95.times do |n|

  notification = User.find(3).notifications.build(title: "Message #{n}",
                                                  content: "Content #{n}",
                                                  read: false)
  notification.save
end