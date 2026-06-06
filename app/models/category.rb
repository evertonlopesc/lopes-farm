# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :items, dependent: :nullify

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :with_items, -> { joins(:items).distinct }
end
