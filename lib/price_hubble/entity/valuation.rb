# frozen_string_literal: true

module PriceHubble
  # The PriceHubble valuation result for a given property.
  #
  # @see https://docs.pricehubble.com/#international-valuation
  class Valuation < BaseEntity
    # Mapped and tracked attributes
    tracked_attr :currency, :sale_price, :sale_price_range, :rent_gross,
                 :rent_gross_range, :rent_net, :rent_net_range, :confidence,
                 :scores, :status, :deal_type, :valuation_date, :country_code

    # Define attribute types for casting
    typed_attr :currency, :string_inquirer
    typed_attr :confidence, :string_inquirer
    typed_attr :deal_type, :string_inquirer
    typed_attr :country_code, :string_inquirer
    typed_attr :sale_price_range, :range
    typed_attr :rent_gross_range, :range
    typed_attr :rent_net_range, :range

    # Associations
    with_options(persist: true, initialize: true) do
      has_one :property
      has_one :scores, class_name: ValuationScores
    end

    # A streamlined helper to get the value by the deal type. (sale price
    # if deal type is +sale+ or gross rent value if deal type is +rent+)
    #
    # @return [Integer, nil] the value of the property
    def value
      return sale_price if deal_type.sale?

      rent_gross
    end

    # A streamlined helper to get the value range by the deal type. (sale price
    # range if deal type is +sale+ or gross rent range if deal type is +rent+)
    #
    # @return [Range, nil] the value range of the property
    def value_range
      return sale_price_range if deal_type.sale?

      rent_gross_range
    end
  end
end
