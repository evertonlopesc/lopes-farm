# frozen_string_literal: true

require "rails_helper"

RSpec.describe BestItemsToSellQuery do
  describe "#call" do
    let!(:fast_item) { create(:item, preparation_time: 10, sale_price: 50.0, additional_cost: 10.0) }
    let!(:slow_item) { create(:item, preparation_time: 60, sale_price: 80.0, additional_cost: 10.0) }

    it "orders by preparation_time ascending" do
      result = described_class.new.call
      expect(result.first.item).to eq(fast_item)
    end

    context "when filtering by category" do
      let(:category)  { create(:category) }
      let!(:cat_item) { create(:item, category:, preparation_time: 5, sale_price: 30.0, additional_cost: 5.0) }

      it "returns only items from the given category" do
        result = described_class.new(category_id: category.id).call
        expect(result.map(&:item)).to contain_exactly(cat_item)
      end
    end
  end
end
