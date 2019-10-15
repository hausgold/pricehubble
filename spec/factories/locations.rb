# frozen_string_literal: true

FactoryBot.define do
  factory :location, class: PriceHubble::Location do
    address { build(:address) }

    trait :full do
      coordinates { build(:coordinates) }
    end
  end
end
