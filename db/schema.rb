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

ActiveRecord::Schema[8.0].define(version: 2026_02_06_000006) do
  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "owner_id", null: false
    t.bigint "category_id", null: false
    t.string "institution"
    t.string "currency", default: "USD", null: false
    t.decimal "cost_basis", precision: 15, scale: 2
    t.boolean "is_active", default: true, null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_accounts_on_category_id"
    t.index ["owner_id", "name"], name: "index_accounts_on_owner_id_and_name", unique: true
    t.index ["owner_id"], name: "index_accounts_on_owner_id"
  end

  create_table "cash_flows", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.date "flow_date", null: false
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.string "flow_type", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "flow_date"], name: "index_cash_flows_on_account_id_and_flow_date"
    t.index ["account_id"], name: "index_cash_flows_on_account_id"
  end

  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "display_order", default: 0, null: false
    t.boolean "is_debt", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["display_order"], name: "index_categories_on_display_order"
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "exchange_rates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "base_currency", null: false
    t.string "target_currency", null: false
    t.decimal "rate", precision: 15, scale: 6, null: false
    t.date "rate_date", null: false
    t.string "source"
    t.datetime "fetched_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["base_currency", "target_currency", "rate_date"], name: "index_exchange_rates_on_currencies_and_date", unique: true
  end

  create_table "owners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_owners_on_name", unique: true
  end

  create_table "value_snapshots", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.date "snapshot_date", null: false
    t.decimal "value", precision: 15, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "snapshot_date"], name: "index_value_snapshots_on_account_id_and_snapshot_date", unique: true
    t.index ["account_id"], name: "index_value_snapshots_on_account_id"
    t.index ["snapshot_date"], name: "index_value_snapshots_on_snapshot_date"
  end

  add_foreign_key "accounts", "categories"
  add_foreign_key "accounts", "owners"
  add_foreign_key "cash_flows", "accounts"
  add_foreign_key "value_snapshots", "accounts"
end
