# coding: utf-8
Office.create!(office_name: "東京",
              office_number: 101,
              office_type: "出勤")
               
Office.create!(office_name: "大阪",
              office_number: 102,
              office_type: "出勤")
               
User.create!(name: "上長１",
             email: "superior1@email.com",
             affiliation: "総務部",
             password: "password",
             password_confirmation: "password",
             employee_number: "101-1101",
             uid: "101-1101",
             office_id: 1,
             superior: true)
             
User.create!(name: "上長２",
             email: "superior2@email.com",
             affiliation: "総務部",
             password: "password",
             password_confirmation: "password",
             employee_number: "101-1102",
             uid: "101-1102",
             office_id: 1,
             superior: true)             
             
User.create!(name: "管理者１",
             email: "admin1@email.com",
             affiliation: "営業部",
             password: "password",
             password_confirmation: "password",
             employee_number: "101-9101",
             uid: "101-9101",
             office_id: 1,
             admin: true)
             
User.create!(name: "管理者２",
             email: "admin2@email.com",
             affiliation: "営業部",
             password: "password",
             password_confirmation: "password",
             employee_number: "101-9102",
             uid: "101-9102",
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
               employee_number: "101-210#{4+n+1}",
               uid: "101-210#{4+n+1}",
               office_id: 1)
end
