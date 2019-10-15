# frozen_string_literal: true

module PriceHubble
  # The common PriceHubble property type object.
  #
  # @see https://docs.pricehubble.com/#types-propertytype
  class PropertyType < BaseEntity
    # Mapped and tracked attributes
    tracked_attr :code, :subcode

    # Define attribute types for casting
    typed_attr :code, :enum, values: %i[apartment house]
    typed_attr :subcode, :enum, values: %i[apartment_normal
                                           apartment_maisonette apartment_attic
                                           apartment_penthouse
                                           apartment_terraced apartment_studio
                                           house_detached house_semi_detached
                                           house_row_corner house_row_middle
                                           house_farm]
  end
end
