# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_05_02_091509) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "action"
    t.string "resource_type"
    t.bigint "resource_id"
    t.text "description"
    t.datetime "performed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount"
    t.string "payment_method", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "transaction_id"
    t.date "payment_date"
    t.bigint "subscription_id", null: false
    t.index ["subscription_id"], name: "index_payments_on_subscription_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "taxpayer_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["taxpayer_id"], name: "index_subscriptions_on_taxpayer_id"
  end

  create_table "taxpayers", force: :cascade do |t|
    t.string "tin", null: false
    t.string "name", null: false
    t.string "email_address", null: false
    t.string "phone_number", null: false
    t.integer "terminals_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  create_table "terminals", force: :cascade do |t|
    t.string "terminal_id", null: false
    t.string "terminal_label", null: false
    t.string "activation_date", null: false
    t.integer "status"
    t.bigint "taxpayer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["taxpayer_id"], name: "index_terminals_on_taxpayer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "user_name", null: false
    t.string "role"
    t.string "email_address", null: false
    t.string "phone_number"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
  end

  add_foreign_key "logs", "users"
  add_foreign_key "payments", "subscriptions"
  add_foreign_key "subscriptions", "taxpayers"
  add_foreign_key "terminals", "taxpayers"
end
