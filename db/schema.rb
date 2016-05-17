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

ActiveRecord::Schema.define(version: 20160517031210) do

  create_table "arrows", force: :cascade do |t|
    t.string   "origin",                   null: false
    t.string   "destination",              null: false
    t.integer  "status",      default: 10, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "arrows", ["destination"], name: "index_arrows_on_destination"
  add_index "arrows", ["origin"], name: "index_arrows_on_origin"

  create_table "users", force: :cascade do |t|
    t.string   "account_id",                 null: false
    t.integer  "user_key",                   null: false
    t.integer  "last_chat_key",              null: false
    t.integer  "last_msg_id",                null: false
    t.integer  "status",        default: 10, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id"
  add_index "users", ["status"], name: "index_users_on_status"
  add_index "users", ["user_key"], name: "index_users_on_user_key"

  create_table "web_messages", force: :cascade do |t|
    t.string   "msg_type",   null: false
    t.integer  "msg_id",     null: false
    t.integer  "user_key",   null: false
    t.integer  "chat_key",   null: false
    t.text     "text",       null: false
    t.integer  "bound",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "web_messages", ["chat_key"], name: "index_web_messages_on_chat_key"
  add_index "web_messages", ["msg_id"], name: "index_web_messages_on_msg_id"
  add_index "web_messages", ["user_key"], name: "index_web_messages_on_user_key"

end
