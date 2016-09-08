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

ActiveRecord::Schema.define(version: 20160907171048) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "donations", force: :cascade do |t|
    t.integer  "location_id",                     null: false
    t.integer  "scheduled_pickup_id",             null: false
    t.datetime "confirmed_at"
    t.datetime "declined_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "size",                default: 0, null: false
    t.text     "notes"
    t.datetime "requested_at"
    t.datetime "picked_up_at"
  end

  add_index "donations", ["location_id", "scheduled_pickup_id"], name: "index_donations_on_location_id_and_scheduled_pickup_id", unique: true, using: :btree
  add_index "donations", ["size"], name: "index_donations_on_size", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string  "address",                                                null: false
    t.string  "zipcode",                                                null: false
    t.text    "notes",                                   default: "",   null: false
    t.integer "user_id",                                                null: false
    t.integer "location_type",                           default: 0,    null: false
    t.boolean "grown_on_site",                           default: true, null: false
    t.decimal "latitude",      precision: 15, scale: 10
    t.decimal "longitude",     precision: 15, scale: 10
  end

  create_table "region_admins", force: :cascade do |t|
    t.integer "user_id"
    t.integer "region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "regions", ["name"], name: "index_regions_on_name", unique: true, using: :btree

  create_table "scheduled_pickups", force: :cascade do |t|
    t.integer  "zone_id",    null: false
    t.datetime "start_at",   null: false
    t.datetime "end_at",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string   "email",      null: false
    t.string   "zipcode",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "subscriptions", ["email", "zipcode"], name: "index_subscriptions_on_email_and_zipcode", unique: true, using: :btree
  add_index "subscriptions", ["zipcode"], name: "index_subscriptions_on_zipcode", using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.string   "email",                                                        null: false
    t.string   "encrypted_password",               limit: 128,                 null: false
    t.string   "confirmation_token",               limit: 128
    t.string   "remember_token",                   limit: 128,                 null: false
    t.string   "name",                                         default: "",    null: false
    t.boolean  "admin",                                        default: false, null: false
    t.datetime "terms_and_conditions_accepted_at"
    t.datetime "organic_growth_asserted_at"
    t.integer  "assigned_zone_id"
    t.datetime "deleted_at"
  end

  add_index "users", ["assigned_zone_id"], name: "index_users_on_assigned_zone_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "zones", force: :cascade do |t|
    t.string   "zipcode",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "start_hour", default: 0, null: false
    t.integer  "end_hour",   default: 0, null: false
    t.integer  "weekday",    default: 0, null: false
    t.integer  "region_id"
  end

  add_index "zones", ["zipcode"], name: "index_zones_on_zipcode", unique: true, using: :btree

end
