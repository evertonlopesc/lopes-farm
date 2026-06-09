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

ActiveRecord::Schema[7.2].define(version: 2026_06_09_150853) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "item_components", force: :cascade do |t|
    t.bigint "parent_item_id", null: false
    t.bigint "component_item_id", null: false
    t.decimal "quantity", precision: 10, scale: 4, default: "1.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["component_item_id"], name: "index_item_components_on_component_item_id"
    t.index ["parent_item_id", "component_item_id"], name: "index_item_components_on_parent_item_id_and_component_item_id", unique: true
    t.index ["parent_item_id"], name: "index_item_components_on_parent_item_id"
    t.check_constraint "parent_item_id <> component_item_id", name: "check_no_self_reference"
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.integer "preparation_time", default: 0, null: false
    t.decimal "sale_price", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "additional_cost", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "output_quantity", default: 1, null: false
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["name"], name: "index_items_on_name", unique: true
    t.check_constraint "output_quantity > 0", name: "check_output_quantity_positive"
  end

  add_foreign_key "item_components", "items", column: "component_item_id"
  add_foreign_key "item_components", "items", column: "parent_item_id"
  add_foreign_key "items", "categories"
end
