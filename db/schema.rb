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

ActiveRecord::Schema.define(version: 20151117204844) do

  create_table "deals", force: :cascade do |t|
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.text     "description"
    t.datetime "seller_finished_at"
    t.datetime "buyer_finished_at"
    t.integer  "seller_status_code", default: 0, null: false
    t.integer  "buyer_status_code",  default: 0, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["buyer_id"], name: "index_deals_on_buyer_id"
    t.index ["buyer_status_code"], name: "index_deals_on_buyer_status_code"
    t.index ["seller_id"], name: "index_deals_on_seller_id"
    t.index ["seller_status_code"], name: "index_deals_on_seller_status_code"
  end

  create_table "favorites", force: :cascade do |t|
    t.string   "user_name"
    t.string   "user_email"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "favorited_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "deal_id",                 null: false
    t.integer  "user_id",                 null: false
    t.text     "content",    default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["deal_id"], name: "index_messages_on_deal_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   default: "", null: false
    t.string   "photo"
    t.text     "description"
    t.integer  "meal_plan_code",         default: 0,  null: false
    t.integer  "status_code",            default: 0,  null: false
    t.integer  "current_deal_id"
    t.datetime "search_start_time"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["status_code"], name: "index_users_on_status_code"
  end

end
