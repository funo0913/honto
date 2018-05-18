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

ActiveRecord::Schema.define(version: 20180518103440) do

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "books", force: :cascade do |t|
    t.string "isbn", null: false
    t.string "title", null: false
    t.string "author", null: false
    t.date "publication", null: false
    t.string "publisher", null: false
    t.integer "review_cnt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tmp_id", default: "", null: false
  end

  create_table "csses", force: :cascade do |t|
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recommends", force: :cascade do |t|
    t.integer "user_id"
    t.integer "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_recommends_on_book_id"
    t.index ["user_id"], name: "index_recommends_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "user_id"
    t.integer "book_id"
    t.integer "status_id"
    t.string "title"
    t.text "innocent_review"
    t.text "review"
    t.boolean "private", default: false
    t.boolean "warning", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_reviews_on_book_id"
    t.index ["status_id"], name: "index_reviews_on_status_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "status_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "nickname", null: false
    t.integer "css_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["css_id"], name: "index_users_on_css_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "warning_reports", force: :cascade do |t|
    t.integer "review_id"
    t.integer "user_id"
    t.boolean "dealt", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["review_id"], name: "index_warning_reports_on_review_id"
    t.index ["user_id"], name: "index_warning_reports_on_user_id"
  end

end
