# coding: utf-8
Office.create!(office_name: "東京",
               office_number: 101,
               office_type: "出勤")
               
User.create!(name: "花田 光司",
             email: "superior@email.com",
             affiliation: "総務部",
             password: "password",
             password_confirmation: "password",
             uid: 1001,
             office_id: 1,
             superior: true)
             
User.create!(name: "花田 虎上",
             email: "superior1@email.com",
             affiliation: "総務部",
             password: "password",
             password_confirmation: "password",
             uid: 1002,
             office_id: 1,
             superior: true)             
             
User.create!(name: "貴乃花",
             email: "admin@email.com",
             affiliation: "営業部",
             password: "password",
             password_confirmation: "password",
             uid: 9001,
             office_id: 1,
             admin: true)
             
User.create!(name: "若乃花",
             email: "admin1@email.com",
             affiliation: "営業部",
             password: "password",
             password_confirmation: "password",
             uid: 9002,
             office_id: 1,
             admin: true)
             
6.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               affiliation: "事務部",
               password: password,
               password_confirmation: password,
               uid: 2000+n+1,
               office_id: 1)
end
