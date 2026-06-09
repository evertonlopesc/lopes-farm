# frozen_string_literal: true

class BestItemsToSellQuery
  DEFAULT_LIMIT = 100

  def initialize(relation: Item.all, category_id: nil, limit: DEFAULT_LIMIT)
    @relation    = relation
    @category_id = category_id
    @limit       = limit
  end

  def call
    scope = @relation
              .includes(:category, item_components: :component_item)
              .then { |r| filter_by_category(r) }

    scope.to_a
         .map     { |item| decorate(item) }
         .sort_by { |d| [d.preparation_time, -d.sale_price, -d.margin, d.component_count] }
         .first(@limit)
  end

  private

  def filter_by_category(relation)
    return relation unless @category_id

    relation.where(category_id: @category_id)
  end

  def decorate(item)
    Data.define(:item, :preparation_time, :sale_price, :margin, :margin_percentage,
                :total_cost, :component_count, :formatted_time).new(
      item:              item,
      preparation_time:  item.total_preparation_time,  # ← era item.preparation_time
      sale_price:        item.sale_price,
      margin:            item.margin,
      margin_percentage: item.margin_percentage,
      total_cost:        item.total_cost,
      component_count:   item.item_components.size,
      formatted_time:    item.formatted_preparation_time
    )
  end
end
