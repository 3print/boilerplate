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

ActiveRecord::Schema.define(version: 2021_08_04_093728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bp_tests", id: :serial, force: :cascade do |t|
    t.string "image"
    t.string "pdf"
    t.integer "int"
    t.json "json"
    t.text "markdown"
    t.text "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "enum"
    t.datetime "approved_at"
    t.datetime "validated_at"
    t.integer "sequence"
    t.integer "multiple_enum", default: [], array: true
    t.integer "image_gravity"
    t.string "image_alt_text"
    t.string "visual"
    t.json "visual_regions"
  end

  create_table "old_passwords", force: :cascade do |t|
    t.string "encrypted_password"
    t.string "password_archivable_type"
    t.integer "password_archivable_id"
    t.string "password_salt"
    t.datetime "created_at"
    t.index ["password_archivable_type", "password_archivable_id"], name: "index_password_archivable"
  end

  create_table "seo_meta", id: :serial, force: :cascade do |t|
    t.integer "meta_owner_id"
    t.string "meta_owner_type"
    t.string "title"
    t.text "description"
    t.string "static_action"
    t.boolean "static_mode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["meta_owner_id", "meta_owner_type"], name: "index_seo_meta_on_meta_owner_id_and_meta_owner_type"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "first_name"
    t.string "last_name"
    t.integer "role"
    t.string "avatar"
    t.integer "avatar_gravity"
    t.datetime "password_changed_at"
    t.datetime "locked_at"
    t.integer "failed_attempts"
    t.string "unlock_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["password_changed_at"], name: "index_users_on_password_changed_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

end
