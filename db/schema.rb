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

ActiveRecord::Schema.define(version: 20150224220353) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "pg_stat_statements"
  enable_extension "uuid-ossp"

  create_table "accounts", id: :uuid, force: :cascade do |t|
    t.string   "name",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",               limit: 255,                 null: false
    t.string   "webhook_url",        limit: 255
    t.string   "webhook_secret",     limit: 255
    t.string   "website_url",        limit: 255
    t.boolean  "prefers_archiving"
    t.text     "signature"
    t.string   "url",                limit: 255
    t.string   "stripe_customer_id", limit: 255
    t.boolean  "is_pro",                         default: false, null: false
    t.string   "forwarding_address"
  end

  add_index "accounts", ["slug"], name: "index_accounts_on_slug", unique: true, using: :btree

  create_table "assignment_events", force: :cascade do |t|
    t.uuid     "conversation_id"
    t.uuid     "user_id"
    t.uuid     "assignee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignment_events", ["conversation_id"], name: "index_assignment_events_on_conversation_id", using: :btree

  create_table "attachments", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "message_id",               null: false
    t.string   "file",         limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_type", limit: 255
    t.string   "file_size",    limit: 255
  end

  create_table "beta_invites", force: :cascade do |t|
    t.string   "email",        limit: 255
    t.string   "invite_token", limit: 255
    t.uuid     "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "beta_invites", ["email"], name: "index_beta_invites_on_email", unique: true, using: :btree

  create_table "canned_responses", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "key",        limit: 255, null: false
    t.text     "message",                null: false
    t.uuid     "account_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "canned_responses", ["key", "account_id"], name: "index_canned_responses_on_key_and_account_id", unique: true, using: :btree

  create_table "conversations", id: :uuid, force: :cascade do |t|
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "account_id",                 null: false
    t.text     "subject"
    t.boolean  "archived",   default: false
    t.string   "tags",       default: [],                 array: true
    t.uuid     "user_id"
  end

  add_index "conversations", ["account_id", "archived"], name: "index_conversations_on_account_id_and_archived", using: :btree
  add_index "conversations", ["account_id"], name: "index_conversations_on_account_id", using: :btree
  add_index "conversations", ["user_id"], name: "index_conversations_on_user_id", using: :btree

  create_table "domain_checks", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "domain"
    t.boolean  "spf_valid",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "memberships", id: :uuid, force: :cascade do |t|
    t.uuid     "account_id",             null: false
    t.uuid     "user_id",                null: false
    t.string   "role",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["account_id", "user_id"], name: "index_memberships_on_account_id_and_user_id", unique: true, using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "messages", id: :uuid, force: :cascade do |t|
    t.uuid     "conversation_id",              null: false
    t.text     "content"
    t.hstore   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "person_id",                    null: false
    t.json     "webhook"
    t.text     "message_id"
    t.uuid     "in_reply_to_id"
    t.text     "html_content",    default: ""
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["person_id"], name: "index_messages_on_person_id", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id",              null: false
    t.integer  "application_id",                 null: false
    t.string   "token",             limit: 255,  null: false
    t.integer  "expires_in",                     null: false
    t.string   "redirect_uri",      limit: 2048, null: false
    t.datetime "created_at",                     null: false
    t.datetime "revoked_at"
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",                null: false
    t.string   "token",             limit: 255, null: false
    t.string   "refresh_token",     limit: 255
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                    null: false
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         limit: 255,  null: false
    t.string   "uid",          limit: 255,  null: false
    t.string   "secret",       limit: 255,  null: false
    t.string   "redirect_uri", limit: 2048, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type",   limit: 255
  end

  add_index "oauth_applications", ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type", using: :btree
  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "people", id: :uuid, force: :cascade do |t|
    t.uuid     "user_id"
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "twitter",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "account_id"
    t.string   "username",   limit: 255
    t.string   "avatar",     limit: 255
  end

  add_index "people", ["account_id", "username"], name: "index_people_on_account_id_and_username", unique: true, using: :btree
  add_index "people", ["email"], name: "index_people_on_email", using: :btree
  add_index "people", ["twitter"], name: "index_people_on_twitter", using: :btree
  add_index "people", ["user_id"], name: "index_people_on_user_id", using: :btree

  create_table "read_receipts", id: :uuid, force: :cascade do |t|
    t.uuid     "person_id"
    t.uuid     "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "read_receipts", ["person_id", "message_id"], name: "index_read_receipts_on_person_id_and_message_id", unique: true, using: :btree

  create_table "sequential", force: :cascade do |t|
    t.string   "model",       limit: 255
    t.string   "column",      limit: 255
    t.string   "scope",       limit: 255
    t.string   "scope_value", limit: 255
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sequential", ["model", "column", "scope", "scope_value"], name: "index_sequential_on_model_and_column_and_scope_and_scope_value", unique: true, using: :btree

  create_table "tag_events", force: :cascade do |t|
    t.uuid     "conversation_id"
    t.uuid     "user_id"
    t.string   "tag",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tag_events", ["conversation_id"], name: "index_tag_events_on_conversation_id", using: :btree

  create_table "users", id: :uuid, force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",        null: false
    t.string   "encrypted_password",     limit: 255, default: ""
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",                    default: 0,         null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.uuid     "invited_by_id"
    t.string   "invited_by_type",        limit: 255
    t.integer  "invitations_count",                  default: 0
    t.string   "notification_setting",   limit: 255, default: "message", null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "webhooks", id: :uuid, force: :cascade do |t|
    t.uuid     "account_id",                null: false
    t.string   "event",         limit: 255, null: false
    t.text     "body"
    t.string   "response_code", limit: 255
    t.text     "response_body"
    t.datetime "response_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "webhooks", ["account_id"], name: "index_webhooks_on_account_id", using: :btree
  add_index "webhooks", ["response_code", "response_at"], name: "index_webhooks_on_response_code_and_response_at", using: :btree

end
