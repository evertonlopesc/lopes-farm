class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items do |t|
      t.string     :name,             null: false
      t.integer    :preparation_time, null: false, default: 0
      t.decimal    :sale_price,       null: false, default: 0, precision: 10, scale: 2
      t.decimal    :additional_cost,  null: false, default: 0, precision: 10, scale: 2
      t.references :category,         null: true,  foreign_key: true

      t.timestamps
    end

    add_index :items, :name, unique: true
  end
end
