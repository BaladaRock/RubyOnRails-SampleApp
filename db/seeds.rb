# Create a main sample user.
User.create!(name: "Example User",
             email: "example@railstutorial.org",
             password:              "exampleuser12345",
             password_confirmation: "exampleuser12345",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# Generate a bunch of additional users.
49.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "firstuser4ever"
  User.create!(name: name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end