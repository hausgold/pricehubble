# frozen_string_literal: true

FactoryBot.define do
  factory :dossier, class: 'PriceHubble::Dossier' do
    property { association(:property) }

    title { 'My fancy dossier title' }
    description { 'My fancy dossier description' }
    deal_type { :sale }
    country_code { 'DE' }
    asking_sale_price { 600_000 }
  end
end
