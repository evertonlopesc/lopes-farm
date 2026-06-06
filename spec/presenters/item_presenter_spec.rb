# frozen_string_literal: true

require "rails_helper"

RSpec.describe ItemPresenter do
  let(:item)      { build(:item, sale_price: 50.0, additional_cost: 10.0, preparation_time: 90) }
  let(:presenter) { described_class.new(item) }

  describe "#type_label" do
    it "returns Primário for primary item" do
      expect(presenter.type_label).to eq("Primário")
    end
  end

  describe "#cost_summary" do
    it "returns formatted currency values" do
      summary = presenter.cost_summary
      expect(summary[:sale_price]).to eq("R$ 50.00")
      expect(summary[:additional_cost]).to eq("R$ 10.00")
    end
  end

  describe "#preparation_time" do
    it "returns formatted time" do
      expect(presenter.preparation_time).to eq("1h 30min")
    end
  end
end
