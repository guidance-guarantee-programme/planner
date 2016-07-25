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

ActiveRecord::Schema.define(version: 20160722124147) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.integer  "booking_request_id", null: false
    t.string   "name",               null: false
    t.string   "email",              null: false
    t.string   "phone",              null: false
    t.integer  "guider_id",          null: false
    t.string   "location_id",        null: false
    t.datetime "proceeded_at",       null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "appointments", ["booking_request_id"], name: "index_appointments_on_booking_request_id", using: :btree
  add_index "appointments", ["location_id"], name: "index_appointments_on_location_id", using: :btree

  create_table "booking_requests", force: :cascade do |t|
    t.string   "location_id",                null: false
    t.string   "name",                       null: false
    t.string   "email",                      null: false
    t.string   "phone",                      null: false
    t.string   "memorable_word",             null: false
    t.string   "age_range",                  null: false
    t.boolean  "accessibility_requirements", null: false
    t.boolean  "marketing_opt_in",           null: false
    t.boolean  "defined_contribution_pot",   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "booking_location_id",        null: false
  end

  create_table "slots", force: :cascade do |t|
    t.integer  "booking_request_id"
    t.date     "date",               null: false
    t.string   "from",               null: false
    t.string   "to",                 null: false
    t.integer  "priority",           null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "slots", ["booking_request_id"], name: "index_slots_on_booking_request_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "uid"
    t.string   "organisation_slug"
    t.string   "organisation_content_id"
    t.string   "permissions"
    t.boolean  "remotely_signed_out",     default: false
    t.boolean  "disabled",                default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_foreign_key "slots", "booking_requests"
end
