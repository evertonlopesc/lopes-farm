# frozen_string_literal: true

class ItemPresenter
  def initialize(item)
    @item = item
  end

  def type_label
    @item.primary? ? "Primário" : "Composto (#{@item.component_depth} nível(is))"
  end

  def cost_summary
    {
      additional_cost:   format_currency(@item.additional_cost),
      total_cost:        format_currency(@item.total_cost),
      sale_price:        format_currency(@item.sale_price),
      margin:            format_currency(@item.margin),
      margin_percentage: "#{@item.margin_percentage}%",
    }
  end

  def preparation_time
    @item.formatted_preparation_time
  end

  private

  def format_currency(value)
    "R$ #{format('%.2f', value)}"
  end
end
