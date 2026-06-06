# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name             { Faker::Commerce.product_name }
    preparation_time { Faker::Number.between(from: 1, to: 120) }
    sale_price       { Faker::Commerce.price(range: 10.0..100.0) }
    additional_cost  { Faker::Commerce.price(range: 1.0..20.0) }
    category         { nil }
  end
end
