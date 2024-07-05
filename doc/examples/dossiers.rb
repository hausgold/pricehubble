#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'config'

# The property to create a dossier for
apartment = {
  location: {
    address: {
      post_code: '22769',
      city: 'Hamburg',
      street: 'Stresemannstr.',
      house_number: '29'
    }
  },
  property_type: { code: :apartment },
  building_year: 1990,
  living_area: 200
}

dossier = PriceHubble::Dossier.new(
  title: 'Customer Dossier for Stresemannstr. 29',
  description: 'Best apartment in the city',
  deal_type: :sale,
  property: apartment,
  country_code: 'DE',
  asking_sale_price: 600_000 # the minimum price the seller is willing to agree
  # valuation_override_sale_price: '', # overwrite the PH value
  # valuation_override_rent_net: '', # overwrite the PH value
  # valuation_override_rent_gross: '', # overwrite the PH value
  # valuation_override_reason_freetext: '' # explain the visitor why
)

# Save the new dossier
pp dossier.save!
pp dossier.id
# => "25de5429-244e-4584-b58e-b0d7428a2377"

# Generate a sharing link for the dossier
pp dossier.link
# => "https://dash.pricehubble.com/shared/dossier/eyJ0eXAiOiJ..."
