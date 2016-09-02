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

ActiveRecord::Schema.define(version: 20160823125447) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "message",            null: false
    t.integer  "user_id"
    t.integer  "booking_request_id", null: false
    t.string   "type",               null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "activities", ["booking_request_id", "type"], name: "index_activities_on_booking_request_id_and_type", using: :btree

  create_table "appointments", force: :cascade do |t|
    t.integer  "booking_request_id",                    null: false
    t.string   "name",                                  null: false
    t.string   "email",                                 null: false
    t.string   "phone",                                 null: false
    t.integer  "guider_id",                             null: false
    t.string   "location_id",                           null: false
    t.datetime "proceeded_at",                          null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "status",                    default: 0, null: false
    t.integer  "fulfilment_time_seconds",   default: 0, null: false
    t.integer  "fulfilment_window_seconds", default: 0, null: false
  end

  add_index "appointments", ["booking_request_id"], name: "index_appointments_on_booking_request_id", using: :btree
  add_index "appointments", ["location_id"], name: "index_appointments_on_location_id", using: :btree

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

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
