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

ActiveRecord::Schema.define(version: 20131104034821) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "accounts", id: false, force: true do |t|
    t.uuid     "id",         null: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "beta_invites", force: true do |t|
    t.string   "email"
    t.string   "invite_token"
    t.uuid     "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "beta_invites", ["email"], name: "index_beta_invites_on_email", unique: true, using: :btree

  create_table "conversations", id: false, force: true do |t|
    t.uuid     "id",         null: false
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "account_id", null: false
  end

  create_table "identities", id: false, force: true do |t|
    t.uuid     "id",              null: false
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "sequential", force: true do |t|
    t.string   "model"
    t.string   "column"
    t.string   "scope"
    t.integer  "scope_value"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: false, force: true do |t|
    t.uuid     "id",         null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
