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

ActiveRecord::Schema.define(version: 20140513232522) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ad_other_fields", force: true do |t|
    t.integer  "ad_id"
    t.string   "tel"
    t.string   "source_url"
    t.string   "thumb_img"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "ad_other_fields", ["ad_id"], name: "index_ad_other_fields_on_ad_id", using: :btree
  add_index "ad_other_fields", ["source_url"], name: "index_ad_other_fields_on_source_url", using: :btree

  create_table "ads", force: true do |t|
    t.integer  "user_id"
    t.integer  "car_model_id"
    t.integer  "make_id"
    t.integer  "body_color_id"
    t.integer  "internal_color_id"
    t.integer  "scrap_id"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.date     "year"
    t.boolean  "year_format"
    t.decimal  "price"
    t.integer  "millage"
    t.integer  "fuel"
    t.integer  "usage_type",        default: 0
    t.boolean  "girbox",            default: false
    t.boolean  "active",            default: false
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ads", ["active", "latitude", "longitude", "fuel", "price"], name: "index_ads_on_active_lat_fuel_price", using: :btree
  add_index "ads", ["active", "latitude", "longitude", "make_id", "car_model_id", "price"], name: "index_ads_on_active_lat_make_model_price", using: :btree
  add_index "ads", ["active", "latitude", "longitude", "make_id", "usage_type", "year", "price"], name: "index_ads_on_active_lat_make_usage_year_price", using: :btree
  add_index "ads", ["user_id"], name: "index_ads_on_user_id", using: :btree

  create_table "car_models", force: true do |t|
    t.string   "name"
    t.integer  "make_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "car_models", ["make_id"], name: "index_car_models_on_make_id", using: :btree
  add_index "car_models", ["name"], name: "index_car_models_on_name", using: :btree

  create_table "colors", force: true do |t|
    t.string   "name"
    t.boolean  "visible",    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "colors", ["name"], name: "index_colors_on_name", using: :btree

  create_table "image_urls", force: true do |t|
    t.integer  "ad_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "image_urls", ["ad_id"], name: "index_image_urls_on_ad_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "locked",     default: true
  end

  add_index "locations", ["name"], name: "index_locations_on_name", using: :btree

  create_table "makes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "year_format"
  end

  add_index "makes", ["name"], name: "index_makes_on_name", using: :btree

  create_table "scraps", force: true do |t|
    t.integer  "count"
    t.string   "url"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", force: true do |t|
    t.integer  "car_model_id"
    t.integer  "make_id"
    t.date     "year_from"
    t.date     "year_to"
    t.integer  "millage_from"
    t.integer  "millage_to"
    t.decimal  "price_from"
    t.decimal  "price_to"
    t.string   "order"
    t.boolean  "girbox"
    t.boolean  "image_has"
    t.integer  "usage_type"
    t.boolean  "exchange"
    t.boolean  "damaged"
    t.integer  "fuel"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "radius"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "username",               default: ""
    t.string   "first_name",             default: ""
    t.string   "last_name",              default: ""
    t.string   "mobile",                 default: ""
    t.string   "tel",                    default: ""
    t.string   "location",               default: ""
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "real",                   default: true
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                 default: true
    t.string   "slug"
    t.boolean  "slug_updated",           default: false
    t.boolean  "admin",                  default: false
    t.integer  "age"
    t.boolean  "gender"
    t.string   "address"
    t.text     "details"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["latitude", "longitude"], name: "index_users_on_latitude_and_longitude", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
