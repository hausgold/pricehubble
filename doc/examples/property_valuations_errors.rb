#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'config'

begin
  # Fetch the valuations for a single property (sale) for today (defaults).
  # This is the bare minimum variant, as a starting point.
  PriceHubble::ValuationRequest.new(
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
      building_year: 2999,
      living_area: 200
    }
  ).perform!
rescue PriceHubble::EntityInvalid => e
  # => #<PriceHubble::EntityInvalid: buildingYear: ...>

  # The error message includes the detailed problem.
  pp e.message
  # => "buildingYear: Must be between 1850 and 2022."
end
