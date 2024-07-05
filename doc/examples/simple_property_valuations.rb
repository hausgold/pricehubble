#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'config'

# Fetch the valuations for a single property (sale) for today (defaults).
# This is the bare minimum variant, as a starting point.
valuations = PriceHubble::ValuationRequest.new(
  property: {
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
).perform!
# => [#<PriceHubble::Valuation ...>]

# Print all relevant valuation attributes
pp valuations.first.attributes.deep_compact
# => {"currency"=>"EUR",
# =>  "sale_price"=>1283400,
# =>  "sale_price_range"=>1180800..1386100,
# =>  "confidence"=>"good",
# =>  "deal_type"=>"sale",
# =>  "valuation_date"=>Thu, 17 Oct 2019,
# =>  "country_code"=>"DE",
# =>  "property"=>
# =>   {"location"=>
# =>     {"address"=>
# =>       {"post_code"=>"22769",
# =>        "city"=>"Hamburg",
# =>        "street"=>"Stresemannstr.",
# =>        "house_number"=>"29"}},
# =>    "property_type"=>{"code"=>:apartment},
# =>    "building_year"=>1990,
# =>    "living_area"=>200}}

# We just want to work on the first valuation
valuation = valuations.first

# Get the deal type dependent value of the property in a generic way.
# (sale price if deal type is sale, and rent gross if deal type is rent)
pp valuation.value
# => 1283400

# Get the upper and lower value range of the property in a generic
# way. The deal type logic is equal to the
# +PriceHubble::Valuation#value+ method.
pp valuation.value_range
# => 1180800..1386100

# Query the valuation confidence in an elegant way
pp valuation.confidence.good?
# => true

# The +PriceHubble::Valuation+ entity is a self contained
# representation of the request and response. This means it includes
# the property, deal type, valuation date, country code, etc it was
# requested for. This makes it easy to process the data because
# everything related is in one place.
pp valuation.property.property_type.apartment?
# => true
