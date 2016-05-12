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

ActiveRecord::Schema.define(version: 20160512085426) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bp_tests", force: true do |t|
    t.string   "image"
    t.string   "pdf"
    t.integer  "int"
    t.json     "json"
    t.text     "markdown"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "enum"
    t.datetime "approved_at"
    t.datetime "validated_at"
    t.integer  "sequence"
    t.integer  "multiple_enum", default: [], array: true
  end

  create_table "seo_meta", force: true do |t|
    t.integer  "meta_owner_id"
    t.string   "meta_owner_type"
    t.string   "title"
    t.text     "description"
    t.string   "static_action"
    t.boolean  "static_mode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "seo_meta", ["meta_owner_id", "meta_owner_type"], name: "index_seo_meta_on_meta_owner_id_and_meta_owner_type", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role"
    t.string   "avatar"
    t.text     "avatar_meta"
    t.integer  "avatar_gravity"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
