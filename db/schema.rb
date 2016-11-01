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

ActiveRecord::Schema.define(version: 20161101160557) do

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string  "name",   limit: 40, default: "", null: false
    t.integer "parent",            default: 0,  null: false
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true

  create_table "categories_posts", force: :cascade do |t|
    t.integer "category_id"
    t.integer "product_id"
  end

  add_index "categories_posts", ["category_id"], name: "index_categories_posts_on_category_id"
  add_index "categories_posts", ["product_id"], name: "index_categories_posts_on_product_id"

  create_table "comments", force: :cascade do |t|
    t.text     "content",    limit: 1000, default: "", null: false
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "comments", ["product_id"], name: "index_comments_on_product_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "line_items", force: :cascade do |t|
    t.integer "product_id"
    t.integer "cart_id"
  end

  add_index "line_items", ["cart_id"], name: "index_line_items_on_cart_id"
  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id"

  create_table "products", force: :cascade do |t|
    t.string   "title",                  limit: 70,                           default: "",   null: false
    t.text     "description",            limit: 2000,                         default: ""
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.decimal  "price",                               precision: 8, scale: 2, default: 0.01, null: false
    t.integer  "user_id"
    t.boolean  "published",                                                   default: true, null: false
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
  end

  add_index "products", ["user_id"], name: "index_products_on_user_id"

  create_table "roles", force: :cascade do |t|
    t.string "name",  default: "", null: false
    t.string "title", default: "", null: false
  end

  add_index "roles", ["name"], name: "index_roles_on_name", unique: true
  add_index "roles", ["title"], name: "index_roles_on_title", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "login",                  limit: 15, default: "", null: false
    t.string   "name",                   limit: 15, default: "", null: false
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.integer  "role_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["login"], name: "index_users_on_login", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["role_id"], name: "index_users_on_role_id"

end
