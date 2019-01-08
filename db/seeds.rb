seed = Settings.seed

User.create!(name: "Thâm Davies",
             email: "thamdv96@gmail.com",
             gender: User.genders[:male],
             date_of_birth: "1996-09-15",
             password: "123123",
             password_confirmation: "123123",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

seed.users_to_create.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  gender = Faker::Number.between(seed.male, seed.female)
  date_of_birth = Faker::Date
    .birthday(seed.min_age, seed.max_age)
  password = "password"
  User.create!(name: name,
               email: email,
               gender: gender,
               date_of_birth: date_of_birth,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end
