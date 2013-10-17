# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131017182112) do

  create_table "courses", force: true do |t|
    t.string   "name"
    t.string   "course_num"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "courses", ["school_id", "name", "course_num"], name: "index_courses_on_school_id_and_name_and_course_num", unique: true

  create_table "pending_requests", force: true do |t|
    t.string   "transfer_school_name"
    t.string   "transfer_school_location"
    t.boolean  "transfer_school_international"
    t.string   "transfer_course_name"
    t.string   "transfer_course_num"
    t.integer  "ur_course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.boolean  "international"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schools", ["name", "location", "international"], name: "index_schools_on_name_and_location_and_international", unique: true

  create_table "transfer_requests", force: true do |t|
    t.integer  "transfer_school_id"
    t.integer  "transfer_course_id"
    t.integer  "ur_course_id"
    t.boolean  "approved"
    t.string   "reasons"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transfer_requests", ["transfer_school_id", "transfer_course_id", "ur_course_id"], name: "unique_transfers", unique: true

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
