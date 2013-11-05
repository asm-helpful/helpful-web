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

ActiveRecord::Schema.define(version: 20131105145048) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "accounts", id: false, force: true do |t|
    t.uuid     "id",         null: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",       null: false
  end

  add_index "accounts", ["slug"], name: "index_accounts_on_slug", unique: true, using: :btree

  create_table "beta_invites", force: true do |t|
    t.string   "email"
    t.string   "invite_token"
    t.uuid     "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "beta_invites", ["email"], name: "index_beta_invites_on_email", unique: true, using: :btree

  create_table "conversations", id: false, force: true do |t|
    t.uuid     "id",                         null: false
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "account_id",                 null: false
    t.string   "status",     default: "new", null: false
  end

  add_index "conversations", ["account_id"], name: "index_conversations_on_account_id", using: :btree

  create_table "memberships", id: false, force: true do |t|
    t.uuid     "id",         null: false
    t.uuid     "account_id", null: false
    t.uuid     "user_id",    null: false
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["account_id", "user_id"], name: "index_memberships_on_account_id_and_user_id", unique: true, using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "messages", id: false, force: true do |t|
    t.uuid     "id",              null: false
    t.string   "type"
    t.uuid     "conversation_id", null: false
    t.string   "from"
    t.text     "content"
    t.hstore   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree

  create_table "people", id: false, force: true do |t|
    t.uuid     "id",         null: false
    t.uuid     "user_id"
    t.string   "name"
    t.string   "email"
    t.string   "twitter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["email"], name: "index_people_on_email", unique: true, using: :btree
  add_index "people", ["twitter"], name: "index_people_on_twitter", unique: true, using: :btree
  add_index "people", ["user_id"], name: "index_people_on_user_id", unique: true, using: :btree

  create_table "users", id: false, force: true do |t|
    t.uuid     "id",                                  null: false
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
