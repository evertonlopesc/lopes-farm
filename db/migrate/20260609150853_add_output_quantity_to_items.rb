class AddOutputQuantityToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :output_quantity, :integer, null: false, default: 1
    add_check_constraint :items, "output_quantity > 0", name: "check_output_quantity_positive"
  end
end
