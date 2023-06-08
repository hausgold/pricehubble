# frozen_string_literal: true

FactoryBot.define do
  factory :valuation, class: 'PriceHubble::Valuation' do
    property { association(:property) }

    deal_type { :sale }
    valuation_date { Date.current }
    country_code { 'DE' }
    currency { 'EUR' }
    sale_price { 1_313_700 }
    sale_price_range { { lower: 1_208_600, upper: 1_418_800 } }
    rent_gross { nil }
    rent_gross_range { nil }
    rent_net { nil }
    rent_net_range { nil }
    confidence { 'good' }
  end
end
