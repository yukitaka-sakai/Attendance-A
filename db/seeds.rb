# coding: utf-8

User.create!(name: "花田 光司",
             email: "superior@email.com",
             affiliation: "総務部",
             password: "password",
             password_confirmation: "password",
             superior: true,
             admin: true)
             
User.create!(name: "花田 虎上",
             email: "superior1@email.com",
             affiliation: "総務部",
             password: "password",
             password_confirmation: "password",
             superior: true,
             admin: true)             
             
User.create!(name: "貴乃花",
             email: "admin@email.com",
             affiliation: "営業部",
             password: "password",
             password_confirmation: "password",
             admin: true)
             
User.create!(name: "若乃花",
             email: "admin1@email.com",
             affiliation: "営業部",
             password: "password",
             password_confirmation: "password",
             admin: true)
             
6.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               affiliation: "事務部",
               password: password,
               password_confirmation: password)
end
