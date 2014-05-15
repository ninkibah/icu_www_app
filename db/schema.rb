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

ActiveRecord::Schema.define(version: 20140511213205) do

  create_table "bad_logins", force: true do |t|
    t.string   "email"
    t.string   "encrypted_password", limit: 32
    t.string   "ip",                 limit: 50
    t.datetime "created_at"
  end

  create_table "carts", force: true do |t|
    t.string   "status",             limit: 20,                          default: "unpaid"
    t.decimal  "total",                          precision: 9, scale: 2
    t.decimal  "original_total",                 precision: 9, scale: 2
    t.string   "payment_method",     limit: 20
    t.string   "payment_ref",        limit: 50
    t.string   "confirmation_email", limit: 50
    t.string   "confirmation_error"
    t.text     "confirmation_text"
    t.boolean  "confirmation_sent",                                      default: false
    t.string   "payment_name",       limit: 100
    t.integer  "user_id"
    t.datetime "payment_completed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "events", force: true do |t|
    t.boolean  "active"
    t.string   "category",           limit: 25
    t.string   "contact",            limit: 50
    t.string   "email",              limit: 50
    t.string   "flyer_file_name"
    t.string   "flyer_content_type"
    t.integer  "flyer_file_size"
    t.datetime "flyer_updated_at"
    t.decimal  "lat",                            precision: 10, scale: 7
    t.string   "location",           limit: 100
    t.decimal  "long",                           precision: 10, scale: 7
    t.string   "name",               limit: 75
    t.string   "note",               limit: 512
    t.string   "phone",              limit: 25
    t.decimal  "prize_fund",                     precision: 8,  scale: 2
    t.string   "source",             limit: 8,                            default: "www2"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "url",                limit: 75
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["active"], name: "index_events_on_active", using: :btree
  add_index "events", ["end_date"], name: "index_events_on_end_date", using: :btree
  add_index "events", ["location"], name: "index_events_on_location", using: :btree
  add_index "events", ["name"], name: "index_events_on_name", using: :btree
  add_index "events", ["start_date"], name: "index_events_on_start_date", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "fees", force: true do |t|
    t.string   "type",              limit: 40
    t.string   "name",              limit: 100
    t.decimal  "amount",                        precision: 9, scale: 2
    t.decimal  "discounted_amount",             precision: 9, scale: 2
    t.string   "years",             limit: 7
    t.integer  "year",              limit: 2
    t.integer  "days",              limit: 2
    t.date     "start_date"
    t.date     "end_date"
    t.date     "sale_start"
    t.date     "sale_end"
    t.date     "age_ref_date"
    t.date     "discount_deadline"
    t.integer  "min_age",           limit: 1
    t.integer  "max_age",           limit: 1
    t.integer  "min_rating",        limit: 2
    t.integer  "max_rating",        limit: 2
    t.string   "url"
    t.boolean  "active",                                                default: false
    t.boolean  "player_required",                                       default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.string   "caption"
    t.string   "dimensions"
    t.string   "credit",            limit: 100
    t.string   "source",            limit: 8,   default: "www2"
    t.integer  "year",              limit: 2
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["caption"], name: "index_images_on_caption", using: :btree
  add_index "images", ["credit"], name: "index_images_on_credit", using: :btree
  add_index "images", ["user_id"], name: "index_images_on_user_id", using: :btree
  add_index "images", ["year"], name: "index_images_on_year", using: :btree

  create_table "items", force: true do |t|
    t.string   "type",           limit: 40
    t.integer  "player_id"
    t.integer  "fee_id"
    t.integer  "cart_id"
    t.string   "description"
    t.string   "player_data"
    t.date     "start_date"
    t.date     "end_date"
    t.decimal  "cost",                        precision: 9, scale: 2
    t.string   "status",         limit: 20,                           default: "unpaid"
    t.string   "source",         limit: 8,                            default: "www2"
    t.string   "payment_method", limit: 20
    t.string   "notes",          limit: 1000,                         default: "--- []\n"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "journal_entries", force: true do |t|
    t.integer  "journalable_id"
    t.string   "journalable_type", limit: 50
    t.string   "action",           limit: 50
    t.string   "column",           limit: 50
    t.string   "by"
    t.string   "ip",               limit: 50
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
    t.string   "source",           limit: 8,  default: "www2"
  end

  add_index "journal_entries", ["journalable_id", "journalable_type"], name: "index_journal_entries_on_journalable_id_and_journalable_type", using: :btree

  create_table "logins", force: true do |t|
    t.integer  "user_id"
    t.string   "error"
    t.string   "roles"
    t.string   "ip",         limit: 50
    t.datetime "created_at"
  end

  create_table "payment_errors", force: true do |t|
    t.integer  "cart_id"
    t.string   "message"
    t.string   "details"
    t.string   "payment_name",       limit: 100
    t.string   "confirmation_email", limit: 50
    t.datetime "created_at"
  end

  create_table "players", force: true do |t|
    t.string   "first_name",         limit: 50
    t.string   "last_name",          limit: 50
    t.string   "status",             limit: 25
    t.string   "source",             limit: 25
    t.integer  "player_id"
    t.string   "gender",             limit: 1
    t.date     "dob"
    t.date     "joined"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "club_id"
    t.string   "fed",                limit: 3
    t.string   "player_title",       limit: 3
    t.string   "arbiter_title",      limit: 3
    t.string   "trainer_title",      limit: 3
    t.string   "email",              limit: 50
    t.string   "address"
    t.string   "home_phone",         limit: 30
    t.string   "mobile_phone",       limit: 30
    t.string   "work_phone",         limit: 30
    t.text     "note"
    t.integer  "legacy_rating",      limit: 2
    t.string   "legacy_rating_type", limit: 20
    t.integer  "legacy_games",       limit: 2
    t.integer  "latest_rating",      limit: 2
  end

  add_index "players", ["first_name", "last_name"], name: "index_players_on_first_name_and_last_name", using: :btree
  add_index "players", ["first_name"], name: "index_players_on_first_name", using: :btree
  add_index "players", ["last_name"], name: "index_players_on_last_name", using: :btree

  create_table "refunds", force: true do |t|
    t.integer  "cart_id"
    t.integer  "user_id"
    t.string   "error"
    t.decimal  "amount",     precision: 9, scale: 2
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

  create_table "uploads", force: true do |t|
    t.string   "access",            limit: 20
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.string   "description",       limit: 150
    t.string   "source",            limit: 8,   default: "www2"
    t.integer  "user_id"
    t.integer  "year",              limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uploads", ["access"], name: "index_uploads_on_access", using: :btree
  add_index "uploads", ["description"], name: "index_uploads_on_description", using: :btree
  add_index "uploads", ["user_id"], name: "index_uploads_on_user_id", using: :btree
  add_index "uploads", ["year"], name: "index_uploads_on_year", using: :btree

  create_table "user_inputs", force: true do |t|
    t.integer "fee_id"
    t.string  "type",            limit: 40
    t.string  "label",           limit: 100
    t.boolean "required",                                            default: true
    t.integer "max_length",      limit: 2
    t.decimal "min_amount",                  precision: 6, scale: 2, default: 1.0
    t.string  "date_constraint", limit: 30,                          default: "none"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "roles"
    t.string   "encrypted_password", limit: 32
    t.string   "salt",               limit: 32
    t.string   "status",                        default: "OK"
    t.integer  "player_id"
    t.date     "expires_on"
    t.datetime "verified_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "theme",              limit: 16
    t.string   "locale",             limit: 2,  default: "en"
  end

end
