# frozen_string_literal: true

FactoryBot.define do
  factory :coordinates, class: PriceHubble::Coordinates do
    latitude { 53.5598602 }
    longitude { 9.9608857 }
  end
end
