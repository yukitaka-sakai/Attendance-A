# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20210106213308) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "next_day"
    t.integer "application_superior"
    t.string "application_superior_name"
    t.datetime "edit_started_at"
    t.datetime "edit_finished_at"
    t.string "edit_next_day"
    t.string "edit_status"
    t.string "status"
    t.string "edit_confirmation"
    t.datetime "overtime_finished_at"
    t.string "overtime_next_day"
    t.string "overtime_note"
    t.string "overtime_status"
    t.string "overtime_confirmation"
    t.string "overtimes"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "offices", force: :cascade do |t|
    t.string "office_name"
    t.integer "office_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "office_type"
  end

  create_table "reports", force: :cascade do |t|
    t.string "application_onemonth_superior_name"
    t.boolean "approval_month_status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "affiliation"
    t.datetime "basic_work_time", default: "2021-01-13 23:00:00"
    t.datetime "designated_work_start_time", default: "2021-01-13 23:30:00"
    t.datetime "designated_work_end_time", default: "2021-01-14 08:30:00"
    t.boolean "superior", default: false
    t.integer "uid"
    t.integer "employee_number"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
