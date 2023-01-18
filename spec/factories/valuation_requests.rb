# frozen_string_literal: true

FactoryBot.define do
  factory :valuation_request, class: 'PriceHubble::ValuationRequest' do
    deal_type { :sale }
    valuation_dates { [Date.current] }
    properties { [build(:property)] }
    return_scores { false }
    country_code { 'DE' }
  end
end
