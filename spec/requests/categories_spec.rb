# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Categories", type: :request do
  let!(:category) { create(:category) }

  describe "GET /categories" do
    it "returns http success" do
      get categories_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /categories/:id" do
    it "returns http success" do
      get category_path(category)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /categories/new" do
    it "returns http success" do
      get new_category_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /categories/:id/edit" do
    it "returns http success" do
      get edit_category_path(category)
      expect(response).to have_http_status(:success)
    end
  end
end
