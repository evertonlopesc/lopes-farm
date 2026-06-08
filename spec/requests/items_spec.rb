# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Items", type: :request do
  let!(:item) { create(:item) }

  describe "GET /items" do
    it "returns http success" do
      get items_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /items/:id" do
    it "returns http success" do
      get item_path(item)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /items/new" do
    it "returns http success" do
      get new_item_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /items/:id/edit" do
    it "returns http success" do
      get edit_item_path(item)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /items/ranking" do
    it "returns http success" do
      get ranking_items_path
      expect(response).to have_http_status(:success)
    end
  end
end
