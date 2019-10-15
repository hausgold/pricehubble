# frozen_string_literal: true

module PriceHubble
  # The common PriceHubble property object.
  #
  # @see https://docs.pricehubble.com/#types-property
  class Property < BaseEntity
    # All valid condition values
    CONDITIONS = %i[renovation_needed well_maintained
                    new_or_recently_renovated].freeze
    # All valid quality values
    QUALITIES = %i[simple normal high_quality luxury].freeze

    # Mapped and tracked attributes
    tracked_attr :location, :property_type, :building_year, :living_area,
                 :land_area, :garden_area, :volume, :number_of_rooms,
                 :number_of_bathrooms, :balcony_area,
                 :number_of_indoor_parking_spaces,
                 :number_of_outdoor_parking_spaces, :floor_number, :has_lift,
                 :energy_label, :has_sauna, :has_pool,
                 :number_of_floors_in_building, :is_furnished, :is_new,
                 :renovation_year

    # Associations
    with_options(initialize: true, persist: true) do
      has_one :location
      has_one :property_type
      has_one :condition, class_name: PropertyConditions
      has_one :quality, class_name: PropertyQualities
    end
  end
end
