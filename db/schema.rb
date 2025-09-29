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

ActiveRecord::Schema[8.0].define(version: 2025_09_29_034106) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "locations", force: :cascade do |t|
    t.bigint "warehouse_id", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "stock_item_id"
    t.index ["stock_item_id"], name: "index_locations_on_stock_item_id"
    t.index ["warehouse_id", "code"], name: "index_locations_on_warehouse_id_and_code", unique: true
    t.index ["warehouse_id"], name: "index_locations_on_warehouse_id"
  end

  create_table "stock_items", force: :cascade do |t|
    t.bigint "warehouse_id", null: false
    t.string "name", null: false
    t.integer "quantity", default: 0, null: false
    t.bigint "location_id"
    t.date "expired_date"
    t.boolean "confirmed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_stock_items_on_location_id"
    t.index ["warehouse_id", "name"], name: "index_stock_items_on_warehouse_id_and_name"
    t.index ["warehouse_id"], name: "index_stock_items_on_warehouse_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "warehouses", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "cold_storage", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "locations", "stock_items"
  add_foreign_key "locations", "warehouses"
  add_foreign_key "stock_items", "locations"
  add_foreign_key "stock_items", "warehouses"
end
