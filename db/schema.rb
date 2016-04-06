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

ActiveRecord::Schema.define(version: 20160405191126) do

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

  create_table "delivery_zones", force: :cascade do |t|
    t.string   "zipcode",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "start_hour", default: 0, null: false
    t.integer  "end_hour",   default: 0, null: false
    t.integer  "weekday",    default: 0, null: false
  end

  add_index "delivery_zones", ["zipcode"], name: "index_delivery_zones_on_zipcode", unique: true, using: :btree

  create_table "locations", force: :cascade do |t|
    t.string  "address",              null: false
    t.string  "zipcode",              null: false
    t.text    "notes",   default: "", null: false
    t.integer "user_id",              null: false
  end

  create_table "scheduled_pickups", force: :cascade do |t|
    t.integer  "delivery_zone_id", null: false
    t.datetime "start_at",         null: false
    t.datetime "end_at",           null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
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
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "email",                                          null: false
    t.string   "encrypted_password", limit: 128,                 null: false
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128,                 null: false
    t.string   "name",                           default: "",    null: false
    t.boolean  "admin",                          default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
