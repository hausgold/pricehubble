# frozen_string_literal: true

module PriceHubble
  # The common PriceHubble address object.
  #
  # @see https://docs.pricehubble.com/#types-address
  class Address < BaseEntity
    # Mapped and tracked attributes
    tracked_attr :post_code, :city, :street, :house_number
  end
end
