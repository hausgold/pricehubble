# frozen_string_literal: true

module PriceHubble
  # The common PriceHubble location object.
  #
  # @see https://docs.pricehubble.com/#types-location
  class Location < BaseEntity
    # Associations
    with_options(initialize: true, persist: true) do
      has_one :address
      has_one :coordinates
    end
  end
end
