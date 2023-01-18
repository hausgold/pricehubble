# frozen_string_literal: true

FactoryBot.define do
  factory :address, class: 'PriceHubble::Address' do
    post_code { '22769' }
    city { 'Hamburg' }
    street { 'Stresemannstr.' }
    house_number { '29' }
  end
end
