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

ActiveRecord::Schema.define(version: 20140630204802) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "pg_stat_statements"
  enable_extension "uuid-ossp"

  create_table "accounts", id: false, force: true do |t|
    t.uuid     "id",                          null: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",                        null: false
    t.string   "webhook_url"
    t.string   "webhook_secret"
    t.string   "website_url"
    t.string   "chargify_subscription_id"
    t.string   "chargify_customer_id"
    t.uuid     "billing_plan_id"
    t.string   "billing_status"
    t.string   "chargify_portal_url"
    t.datetime "chargify_portal_valid_until"
    t.boolean  "prefers_archiving"
    t.text     "signature"
    t.string   "url"
    t.string   "stripe_customer_id"
  end

  add_index "accounts", ["billing_plan_id"], name: "index_accounts_on_billing_plan_id", using: :btree
  add_index "accounts", ["chargify_subscription_id"], name: "index_accounts_on_chargify_subscription_id", using: :btree
  add_index "accounts", ["slug"], name: "index_accounts_on_slug", unique: true, using: :btree

  create_table "assignment_events", force: true do |t|
    t.uuid     "conversation_id"
    t.uuid     "user_id"
    t.uuid     "assignee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignment_events", ["conversation_id"], name: "index_assignment_events_on_conversation_id", using: :btree

  create_table "attachments", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "message_id",   null: false
    t.string   "file",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_type"
    t.string   "file_size"
  end

  create_table "beta_invites", force: true do |t|
    t.string   "email"
    t.string   "invite_token"
    t.uuid     "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "beta_invites", ["email"], name: "index_beta_invites_on_email", unique: true, using: :btree

  create_table "billing_plans", id: false, force: true do |t|
    t.uuid     "id",                  null: false
    t.string   "slug"
    t.string   "name"
    t.string   "chargify_product_id"
    t.integer  "max_conversations"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "canned_responses", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "key",        null: false
    t.text     "message",    null: false
    t.uuid     "account_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "canned_responses", ["key", "account_id"], name: "index_canned_responses_on_key_and_account_id", unique: true, using: :btree

  create_table "conversations", id: false, force: true do |t|
    t.uuid     "id",                         null: false
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "account_id",                 null: false
    t.text     "subject"
    t.boolean  "archived",   default: false
    t.string   "tags",       default: [],                 array: true
    t.uuid     "user_id"
    t.boolean  "hidden",     default: false, null: false
  end

  add_index "conversations", ["account_id", "archived"], name: "index_conversations_on_account_id_and_archived", using: :btree
  add_index "conversations", ["hidden"], name: "index_conversations_on_hidden", using: :btree
  add_index "conversations", ["user_id"], name: "index_conversations_on_user_id", using: :btree

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
    t.uuid     "conversation_id", null: false
    t.text     "content"
    t.hstore   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "person_id",       null: false
    t.json     "webhook"
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["person_id"], name: "index_messages_on_person_id", using: :btree

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id",              null: false
    t.integer  "application_id",                 null: false
    t.string   "token",                          null: false
    t.integer  "expires_in",                     null: false
    t.string   "redirect_uri",      limit: 2048, null: false
    t.datetime "created_at",                     null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.string   "redirect_uri", limit: 2048, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "oauth_applications", ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type", using: :btree
  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "people", id: false, force: true do |t|
    t.uuid     "id",         null: false
    t.uuid     "user_id"
    t.string   "name"
    t.string   "email"
    t.string   "twitter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "account_id"
    t.string   "username"
    t.string   "avatar"
  end

  add_index "people", ["account_id", "username"], name: "index_people_on_account_id_and_username", unique: true, using: :btree
  add_index "people", ["email"], name: "index_people_on_email", using: :btree
  add_index "people", ["twitter"], name: "index_people_on_twitter", using: :btree
  add_index "people", ["user_id"], name: "index_people_on_user_id", using: :btree

  create_table "read_receipts", id: false, force: true do |t|
    t.uuid     "id",         null: false
    t.uuid     "person_id"
    t.uuid     "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "read_receipts", ["person_id", "message_id"], name: "index_read_receipts_on_person_id_and_message_id", unique: true, using: :btree

  create_table "sequential", force: true do |t|
    t.string   "model"
    t.string   "column"
    t.string   "scope"
    t.string   "scope_value"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sequential", ["model", "column", "scope", "scope_value"], name: "index_sequential_on_model_and_column_and_scope_and_scope_value", unique: true, using: :btree

  create_table "tag_events", force: true do |t|
    t.uuid     "conversation_id"
    t.uuid     "user_id"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tag_events", ["conversation_id"], name: "index_tag_events_on_conversation_id", using: :btree

  create_table "users", id: false, force: true do |t|
    t.uuid     "id",                                  null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
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
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.uuid     "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "webhooks", id: false, force: true do |t|
    t.uuid     "id",            null: false
    t.uuid     "account_id",    null: false
    t.string   "event",         null: false
    t.text     "body"
    t.string   "response_code"
    t.text     "response_body"
    t.datetime "response_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "webhooks", ["account_id"], name: "index_webhooks_on_account_id", using: :btree
  add_index "webhooks", ["response_code", "response_at"], name: "index_webhooks_on_response_code_and_response_at", using: :btree

end
