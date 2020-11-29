# Create a main sample user.
User.create!(name: "Example User",
             email: "example@railstutorial.org",
             password:              "exampleuser12345",
             password_confirmation: "exampleuser12345")

# Generate a bunch of additional users.
49.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "firstuser4ever"
  User.create!(name: name,
               email: email,
               password:              password,
               password_confirmation: password)
end