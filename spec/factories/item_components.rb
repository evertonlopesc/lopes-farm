# frozen_string_literal: true

FactoryBot.define do
  factory :item_component do
    parent_item    { association :item }
    component_item { association :item }
    quantity       { 1.0 }
  end
end
