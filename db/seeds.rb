# coding: utf-8

User.create!(name: "花田 光司",
             email: "superior@email.com",
             department: "総務部",
             password: "password",
             password_confirmation: "password",
             superior: true,
             admin: true)
             
User.create!(name: "花田 虎上",
             email: "admin@email.com",
             department: "営業部",
             password: "password",
             password_confirmation: "password",
             admin: true)             
             
60.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               department: "事務部",
               password: password,
               password_confirmation: password)
end
