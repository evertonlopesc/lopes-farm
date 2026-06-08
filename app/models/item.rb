# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :category, optional: true

  has_many :item_components,
           foreign_key: :parent_item_id,
           dependent: :destroy,
           inverse_of: :parent_item
  accepts_nested_attributes_for :item_components,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :components,
           through: :item_components,
           source: :component_item

  has_many :component_of_joins,
           class_name: "ItemComponent",
           foreign_key: :component_item_id,
           dependent: :destroy,
           inverse_of: :component_item

  has_many :used_in,
           through: :component_of_joins,
           source: :parent_item

  validates :name,             presence: true, uniqueness: { case_sensitive: false }
  validates :preparation_time, numericality: { greater_than_or_equal_to: 0 }
  validates :sale_price,       numericality: { greater_than_or_equal_to: 0 }
  validates :additional_cost,  numericality: { greater_than_or_equal_to: 0 }

  def total_cost
    additional_cost + component_costs
  end

  def margin
    sale_price - total_cost
  end

  def margin_percentage
    return 0 if sale_price.zero?

    (margin / sale_price * 100).round(2)
  end

  def primary?
    item_components.none?
  end

  def composite?
    item_components.any?
  end

  def component_depth
    return 0 if primary?

    1 + components.map(&:component_depth).max
  end

  def depends_on?(other, visited = Set.new)
    return false if visited.include?(id)

    visited.add(id)
    components.any? { |c| c == other || c.depends_on?(other, visited) }
  end

  def formatted_preparation_time
    time = total_preparation_time

    if time < 60
      "#{time} min"
    else
      hours   = time / 60
      minutes = time % 60
      minutes.zero? ? "#{hours.to_i} h" : "#{hours.to_i} h #{minutes.to_i} min"
    end
  end

  def total_preparation_time
    preparation_time + component_preparation_time
  end

  private

  def component_preparation_time
    item_components.sum { |ic| ic.quantity * ic.component_item.total_preparation_time }
  end

  def component_costs
    item_components.sum { |ic| ic.quantity * ic.component_item.total_cost }
  end
end
