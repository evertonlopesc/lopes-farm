# frozen_string_literal: true

class ItemComponent < ApplicationRecord
  belongs_to :parent_item,    class_name: "Item"
  belongs_to :component_item, class_name: "Item"

  validates :quantity, numericality: { greater_than: 0 }
  validate  :no_self_reference
  validate  :no_circular_dependency

  private

  def no_self_reference
    return unless parent_item_id == component_item_id

    errors.add(:component_item, :invalid, message: "não pode referenciar a si mesmo")
  end

  def no_circular_dependency
    return unless parent_item && component_item
    return unless component_item.depends_on?(parent_item)

    errors.add(:component_item, :invalid, message: "cria dependência circular")
  end
end
