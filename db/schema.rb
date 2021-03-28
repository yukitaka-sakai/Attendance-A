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

ActiveRecord::Schema.define(version: 20210309164245) do

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
    t.string "before_application_superior_name"
    t.datetime "edit_started_at"
    t.datetime "edit_finished_at"
    t.string "edit_next_day"
    t.datetime "before_started_at"
    t.datetime "before_finished_at"
    t.string "before_next_day"
    t.date "edit_approval_date"
    t.string "edit_note"
    t.string "before_edit_note"
    t.datetime "log_started_at"
    t.datetime "log_finished_at"
    t.string "edit_status"
    t.string "status"
    t.string "before_edit_status"
    t.string "edit_confirmation"
    t.string "before_edit_confirmation"
    t.datetime "overtime_finished_at"
    t.string "overtime_next_day"
    t.string "overtime_note"
    t.string "overtime_status"
    t.string "overtime_confirmation"
    t.string "overtime_application_superior_name"
    t.datetime "log_overtime_finished_at"
    t.string "log_overtime_next_day"
    t.string "log_overtime_note"
    t.string "log_overtime_status"
    t.string "log_overtime_confirmation"
    t.string "log_application_superior_name"
    t.string "overtimes"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "offices", force: :cascade do |t|
    t.string "office_name"
    t.integer "office_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "office_type"
  end

  create_table "reports", force: :cascade do |t|
    t.string "application_onemonth_superior_name"
    t.string "approval_month_status"
    t.date "report_month"
    t.string "report_confirmation"
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
    t.datetime "basic_work_time", default: "2021-03-27 23:00:00"
    t.datetime "designated_work_start_time", default: "2021-03-27 23:30:00"
    t.datetime "designated_work_end_time", default: "2021-03-28 08:30:00"
    t.boolean "superior", default: false
    t.string "uid"
    t.string "employee_number"
    t.integer "office_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
