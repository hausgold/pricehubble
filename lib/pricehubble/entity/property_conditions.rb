# frozen_string_literal: true

module PriceHubble
  # The nested PriceHubble property condition object.
  #
  # @see https://docs.pricehubble.com/#types-property
  class PropertyConditions < BaseEntity
    # Mapped and tracked attributes
    tracked_attr :bathrooms, :kitchen, :flooring, :windows, :masonry

    # Define attribute types for casting
    with_options(values: Property::CONDITIONS) do
      typed_attr :bathrooms, :enum
      typed_attr :kitchen, :enum
      typed_attr :flooring, :enum
      typed_attr :windows, :enum
      typed_attr :masonry, :enum
    end
  end
end
