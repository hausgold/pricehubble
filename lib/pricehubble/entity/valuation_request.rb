# frozen_string_literal: true

module PriceHubble
  # The PriceHubble valuation request for one or more properties.
  #
  # @see https://docs.pricehubble.com/#international-valuation
  class ValuationRequest < BaseEntity
    # Configure the client to use
    client :valuation

    # Mapped and tracked attributes
    tracked_attr :deal_type, :valuation_dates, :properties, :return_scores,
                 :country_code

    # Define attribute types for casting
    typed_attr :deal_type, :enum, values: %i[sale rent]
    typed_attr :valuation_dates, :date_array
    typed_attr :country_code, :string_inquirer

    # Associations
    has_many :properties, fallback_from: :property,
                          persist: true,
                          initialize: true

    # Set some defaults when initialized
    after_initialize do
      self.deal_type ||= :sale
      self.valuation_dates ||= [Date.current]
      self.return_scores = false if return_scores.nil?
      self.country_code ||= 'DE'
    end

    # For transportation the +properties+ array name must be changed to reflect
    # the actual API specification.
    #
    # @return [Symbol] the sanitized name of the properties array
    def sanitize_attr_key_properties
      :valuation_inputs
    end

    # For transportation the +properties+ array must be sanitized
    # to reflect the actual API specification.
    #
    # @return [Array<Hash{String => Mixed}>] the sanitized properties
    def sanitize_attr_properties
      properties.map { |prop| { property: prop.attributes(true) } }
    end

    # Perform the property valuation request.
    #
    # @param args [Hash{Symbol => Mixed}] additional options
    # @return [Array<PriceHubble::Valuation>] the valuation results
    def perform(**args)
      client.property_value(self, **args) || []
    end

    # Generate bang method variants
    bangers :perform
  end
end
