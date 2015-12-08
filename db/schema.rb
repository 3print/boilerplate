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

ActiveRecord::Schema.define(version: 20151208150123) do

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
    t.string   "enum"
    t.datetime "approved_at"
    t.datetime "validated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "comment"
    t.integer  "owner_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "x"
    t.float    "y"
    t.float    "dx"
    t.float    "dy"
  end

  add_index "comments", ["owner_id"], name: "index_comments_on_owner_id", using: :btree
  add_index "comments", ["target_id", "target_type"], name: "index_comments_on_target_id_and_target_type", using: :btree

  create_table "customers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "folders", force: true do |t|
    t.string   "title"
    t.string   "ref"
    t.string   "stores"
    t.integer  "status"
    t.string   "tags"
    t.string   "designers"
    t.boolean  "sold"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.integer  "customer_id"
  end

  add_index "folders", ["customer_id"], name: "index_folders_on_customer_id", using: :btree
  add_index "folders", ["owner_id"], name: "index_folders_on_owner_id", using: :btree

  create_table "items", force: true do |t|
    t.integer  "folder_id"
    t.integer  "owner_id"
    t.string   "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "items", ["folder_id"], name: "index_items_on_folder_id", using: :btree
  add_index "items", ["owner_id"], name: "index_items_on_owner_id", using: :btree

  create_table "news_items", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.date     "date"
    t.string   "origin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", force: true do |t|
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "file"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["kind"], name: "index_photos_on_kind", using: :btree
  add_index "photos", ["owner_type", "owner_id"], name: "index_photos_on_owner_type_and_owner_id", using: :btree

  create_table "portraits", force: true do |t|
    t.string   "name"
    t.string   "function"
    t.text     "description"
    t.integer  "seq"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "press_items", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipes", force: true do |t|
    t.integer  "seq"
    t.string   "name"
    t.string   "wine"
    t.string   "quantity"
    t.text     "ingredients"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.integer  "owner_id"
    t.string   "image"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "versions", ["item_id"], name: "index_versions_on_item_id", using: :btree
  add_index "versions", ["owner_id"], name: "index_versions_on_owner_id", using: :btree

  create_table "wines", force: true do |t|
    t.string   "name"
    t.text     "head"
    t.text     "description"
    t.string   "tech_sheet"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
