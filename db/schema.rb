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

ActiveRecord::Schema.define(version: 20131013154451) do

  create_table "clubs", force: true do |t|
    t.string   "county",     limit: 20
    t.string   "name",       limit: 50
    t.string   "city",       limit: 50
    t.string   "district",   limit: 50
    t.string   "contact",    limit: 50
    t.string   "email",      limit: 50
    t.string   "phone",      limit: 50
    t.string   "address",    limit: 100
    t.string   "web",        limit: 100
    t.string   "meet"
    t.boolean  "active"
    t.decimal  "lat",                    precision: 10, scale: 7
    t.decimal  "long",                   precision: 10, scale: 7
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "journal_entries", force: true do |t|
    t.integer  "journalable_id"
    t.string   "journalable_type", limit: 50
    t.string   "action",           limit: 50
    t.string   "column",           limit: 50
    t.string   "by",               limit: 50
    t.string   "ip",               limit: 50
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
  end

  add_index "journal_entries", ["journalable_id", "journalable_type"], name: "index_journal_entries_on_journalable_id_and_journalable_type", using: :btree

  create_table "logins", force: true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "error"
    t.string   "roles"
    t.string   "ip",         limit: 39
    t.datetime "created_at"
  end

  create_table "translations", force: true do |t|
    t.string   "locale",      limit: 2
    t.string   "key"
    t.string   "value"
    t.string   "english"
    t.string   "old_english"
    t.string   "user"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "roles"
    t.string   "encrypted_password", limit: 32
    t.string   "salt",               limit: 32
    t.string   "status",                        default: "OK"
    t.integer  "icu_id"
    t.date     "expires_on"
    t.datetime "verified_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "theme",              limit: 16
    t.string   "locale",             limit: 2,  default: "en"
  end

end
