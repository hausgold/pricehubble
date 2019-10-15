#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './config'

# Build a property with all relevant information for the valuation. This
# example reflects not the full list of supported fields, [see the API
# specification](https://docs.pricehubble.com/#types-property) for the full
# details.
apartment = PriceHubble::Property.new(
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
  living_area: 200,
  balcony_Area: 30,
  floor_number: 5,
  has_lift: true,
  is_furnished: false,
  is_new: false,
  renovation_year: 2014,
  condition: {
    bathrooms: :well_maintained,
    kitchen: :well_maintained,
    flooring: :well_maintained,
    windows: :well_maintained,
    masonry: :well_maintained
  },
  quality: {
    bathrooms: :normal,
    kitchen: :normal,
    flooring: :normal,
    windows: :normal,
    masonry: :normal
  }
)

house = PriceHubble::Property.new(
  location: {
    address: {
      post_code: '22769',
      city: 'Hamburg',
      street: 'Stresemannstr.',
      house_number: '29'
    }
  },
  property_type: { code: :house },
  building_year: 1990,
  land_area: 100,
  living_area: 500,
  number_of_floors_in_building: 5
)

# Fetch the property valuations for multiple properties, on multiple dates
request = PriceHubble::ValuationRequest.new(
  deal_type: :sale,
  properties: [apartment, house],
  # The dates order is reflected on the valuations list
  valuation_dates: [
    1.year.ago,
    Date.current,
    1.year.from_now
  ]
)
valuations = request.perform!

# Print the valuations in a simple ASCII table. This is just a
# demonstration of how to use the valuations for a simple usecase.
require 'terminal-table'
table = Terminal::Table.new do |tab|
  tab << ['Deal Type', 'Property Type', *request.valuation_dates.map(&:year)]
  tab << :separator
  # Group the valuations by the property they represent
  valuations.group_by(&:property).each do |property, valuations|
    tab << [request.deal_type, property.property_type.code,
            *valuations.map { |val| "#{val.value} #{val.currency}" }]
  end
end
puts table
# => +-----------+---------------+-------------+-------------+-------------+
# => | Deal Type | Property Type | 2018        | 2019        | 2020        |
# => +-----------+---------------+-------------+-------------+-------------+
# => | sale      | apartment     | 1282100 EUR | 1373100 EUR | 1420100 EUR |
# => | sale      | house         | 1824800 EUR | 1950900 EUR | 2016000 EUR |
# => +-----------+---------------+-------------+-------------+-------------+
