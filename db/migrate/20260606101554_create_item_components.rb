class CreateItemComponents < ActiveRecord::Migration[7.2]
  def change
    create_table :item_components do |t|
      t.references :parent_item,    null: false, foreign_key: { to_table: :items }
      t.references :component_item, null: false, foreign_key: { to_table: :items }
      t.decimal    :quantity,       null: false, default: 1, precision: 10, scale: 4

      t.timestamps
    end

    add_index :item_components, %i[parent_item_id component_item_id], unique: true
    add_check_constraint :item_components,
                         "parent_item_id <> component_item_id",
                         name: "check_no_self_reference"
  end
end
