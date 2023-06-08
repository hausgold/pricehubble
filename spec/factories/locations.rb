# frozen_string_literal: true

FactoryBot.define do
  factory :location, class: 'PriceHubble::Location' do
    address { association(:address) }

    trait :full do
      coordinates { association(:coordinates) }
    end
  end
end
