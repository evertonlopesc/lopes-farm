# frozen_string_literal: true

require "rails_helper"

RSpec.describe Item, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_numericality_of(:sale_price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:additional_cost).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:preparation_time).is_greater_than_or_equal_to(0) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:category).optional }
    it { is_expected.to have_many(:item_components).dependent(:destroy) }
    it { is_expected.to have_many(:components).through(:item_components) }
  end

  describe "#total_cost" do
    context "when item is primary" do
      subject(:item) { build(:item, additional_cost: 5.0) }

      it "returns only its own additional_cost" do
        expect(item.total_cost).to eq(5.0)
      end
    end

    context "when item is composite" do
      let(:flour) { create(:item, additional_cost: 2.0) }
      let(:bread) { create(:item, additional_cost: 1.0) }

      before { create(:item_component, parent_item: bread, component_item: flour, quantity: 3) }

      it "returns additional_cost plus sum of components" do
        expect(bread.total_cost).to eq(7.0)
      end
    end
  end

  describe "#margin" do
    subject(:item) { build(:item, sale_price: 50.0, additional_cost: 10.0) }

    it "returns sale_price minus total_cost" do
      expect(item.margin).to eq(40.0)
    end
  end

  describe "#primary?" do
    context "when item has no components" do
      subject(:item) { create(:item) }

      it { expect(item.primary?).to be true }
    end

    context "when item has components" do
      let(:parent) { create(:item) }
      let(:child)  { create(:item) }

      before { create(:item_component, parent_item: parent, component_item: child) }

      it { expect(parent.primary?).to be false }
    end
  end

  describe "#depends_on?" do
    let(:a) { create(:item) }
    let(:b) { create(:item) }
    let(:c) { create(:item) }

    before do
      create(:item_component, parent_item: a, component_item: b)
      create(:item_component, parent_item: b, component_item: c)
    end

    it "detects indirect dependency" do
      expect(a.depends_on?(c)).to be true
    end

    it "returns false when there is no dependency" do
      expect(c.depends_on?(a)).to be false
    end
  end

  describe "#formatted_preparation_time" do
    it "returns minutes when less than 60" do
      item = build(:item, preparation_time: 30)
      expect(item.formatted_preparation_time).to eq("30 min")
    end

    it "returns hours when exactly 60" do
      item = build(:item, preparation_time: 60)
      expect(item.formatted_preparation_time).to eq("1h")
    end

    it "returns hours and minutes when over 60" do
      item = build(:item, preparation_time: 90)
      expect(item.formatted_preparation_time).to eq("1h 30min")
    end
  end

  describe "#total_preparation_time" do
    context "when item is primary" do
      subject(:item) { build(:item, preparation_time: 30) }

      it "returns only its own preparation_time" do
        expect(item.total_preparation_time).to eq(30)
      end
    end

    context "when item is composite" do
      let(:flour) { create(:item, preparation_time: 10, additional_cost: 2.0) }
      let(:bread) { create(:item, preparation_time: 20, additional_cost: 1.0) }

      before { create(:item_component, parent_item: bread, component_item: flour, quantity: 2) }

      it "returns own time plus components time times quantity" do
        # 20 + (2 × 10) = 40
        expect(bread.total_preparation_time).to eq(40)
      end
    end
  end
end
