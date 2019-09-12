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

ActiveRecord::Schema.define(version: 2019_08_28_142658) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", id: :serial, force: :cascade do |t|
    t.string "message", null: false
    t.integer "user_id"
    t.integer "booking_request_id", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_request_id", "type"], name: "index_activities_on_booking_request_id_and_type"
  end

  create_table "appointments", id: :serial, force: :cascade do |t|
    t.integer "booking_request_id", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.integer "guider_id", null: false
    t.string "location_id", null: false
    t.datetime "proceeded_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.integer "fulfilment_time_seconds", default: 0, null: false
    t.integer "fulfilment_window_seconds", default: 0, null: false
    t.string "memorable_word", default: "", null: false
    t.date "date_of_birth"
    t.boolean "defined_contribution_pot_confirmed", default: true, null: false
    t.boolean "accessibility_requirements", default: false, null: false
    t.string "additional_info", limit: 500, default: "", null: false
    t.datetime "processed_at"
    t.index ["booking_request_id"], name: "index_appointments_on_booking_request_id"
    t.index ["guider_id", "proceeded_at"], name: "index_appointments_on_guider_id_and_proceeded_at"
    t.index ["location_id"], name: "index_appointments_on_location_id"
  end

  create_table "audits", id: :serial, force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "bookable_slots", force: :cascade do |t|
    t.bigint "schedule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "guider_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.index ["schedule_id"], name: "index_bookable_slots_on_schedule_id"
  end

  create_table "booking_requests", id: :serial, force: :cascade do |t|
    t.string "location_id", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "memorable_word", null: false
    t.string "age_range", null: false
    t.boolean "accessibility_requirements", null: false
    t.boolean "defined_contribution_pot_confirmed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "booking_location_id", null: false
    t.date "date_of_birth"
    t.integer "status", default: 0, null: false
    t.string "additional_info", limit: 500, default: "", null: false
    t.boolean "placed_by_agent", default: false, null: false
    t.integer "where_you_heard", default: 0, null: false
    t.integer "agent_id"
    t.string "address_line_one", default: "", null: false
    t.string "address_line_two", default: "", null: false
    t.string "address_line_three", default: "", null: false
    t.string "town", default: "", null: false
    t.string "county", default: "", null: false
    t.string "postcode", default: "", null: false
    t.string "gdpr_consent", default: "", null: false
  end

  create_table "organisation_lookups", force: :cascade do |t|
    t.string "organisation", default: "", null: false
    t.string "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_organisation_lookups_on_location_id"
  end

  create_table "reporting_summaries", force: :cascade do |t|
    t.string "location_id", null: false
    t.string "name", null: false
    t.boolean "four_week_availability", null: false
    t.date "first_available_slot_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.string "location_id", null: false
    t.boolean "monday_am", default: false, null: false
    t.boolean "monday_pm", default: false, null: false
    t.boolean "tuesday_am", default: false, null: false
    t.boolean "tuesday_pm", default: false, null: false
    t.boolean "wednesday_am", default: false, null: false
    t.boolean "wednesday_pm", default: false, null: false
    t.boolean "thursday_am", default: false, null: false
    t.boolean "thursday_pm", default: false, null: false
    t.boolean "friday_am", default: false, null: false
    t.boolean "friday_pm", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_schedules_on_location_id"
  end

  create_table "slots", id: :serial, force: :cascade do |t|
    t.integer "booking_request_id"
    t.date "date", null: false
    t.string "from", null: false
    t.string "to", null: false
    t.integer "priority", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_request_id"], name: "index_slots_on_booking_request_id"
  end

  create_table "status_transitions", force: :cascade do |t|
    t.bigint "appointment_id"
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_status_transitions_on_appointment_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "uid"
    t.string "organisation_slug"
    t.string "organisation_content_id"
    t.string "permissions"
    t.boolean "remotely_signed_out", default: false
    t.boolean "disabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bookable_slots", "schedules"
  add_foreign_key "slots", "booking_requests"
end
