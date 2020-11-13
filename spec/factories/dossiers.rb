# frozen_string_literal: true

FactoryBot.define do
  factory :dossier, class: PriceHubble::Dossier do
    title { 'My fancy dossier title' }
    description { 'My fancy dossier description' }
    deal_type { :sale }
    property { build(:property) }
    country_code { 'DE' }
    asking_sale_price { 600_000 }
  end
end
