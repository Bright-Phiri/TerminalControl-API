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

ActiveRecord::Schema[8.0].define(version: 2025_02_06_064746) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "payments", force: :cascade do |t|
    t.bigint "taxpayer_id", null: false
    t.date "period"
    t.decimal "amount"
    t.string "payment_method", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "transaction_id"
    t.index ["taxpayer_id"], name: "index_payments_on_taxpayer_id"
  end

  create_table "taxpayers", force: :cascade do |t|
    t.string "tin", null: false
    t.string "name", null: false
    t.string "email_address", null: false
    t.string "phone_number", null: false
    t.integer "terminals_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  add_foreign_key "payments", "taxpayers"
  add_foreign_key "terminals", "taxpayers"
end
