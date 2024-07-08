# frozen_string_literal: true

module PriceHubble
  # The PriceHubble dossier for a single property.
  #
  # @see https://docs.pricehubble.com/#international-dossier-creation
  class Dossier < BaseEntity
    # Configure the client to use
    client :dossiers

    # Mapped and tracked attributes
    tracked_attr :id, :deal_type, :property, :country_code,
                 :title, :description, :asking_sale_price,
                 :valuation_override_sale_price, :valuation_override_rent_net,
                 :valuation_override_rent_gross,
                 :valuation_override_reason_freetext, :logo, :images

    # Define attribute types for casting
    typed_attr :deal_type, :enum, values: %i[sale rent]
    typed_attr :country_code, :string_inquirer

    # Associations
    has_one :property, persist: true, initialize: true

    # Set some defaults when initialized
    after_initialize do
      self.deal_type ||= :sale
      self.country_code ||= 'DE'
    end

    # Save the dossier.
    #
    # @param args [Hash{Symbol => Mixed}] additional options
    # @return [Boolean] the result state
    def save(**args)
      # When the current entity is already persisted, we send an update
      if id.present?
        # Skip making requests when the current entity is not dirty
        return true unless changed?

        # The current entity is dirty, so send an update request
        return client.update_dossier(self, **args)
      end

      # Otherwise we send a new creation request
      client.create_dossier(self, **args) && true
    end

    # Deletes the instance at the remote application and freezes this
    # instance to reflect that no changes should be made (since they can't
    # be persisted).
    #
    # @param args [Hash{Symbol => Mixed}] addition settings
    # @return [PriceHubble::Dossier, false] whenever the deletion
    #   was successful
    def delete(**args)
      client.delete_dossier(self, **args) || false
    end
    alias destroy delete

    # Create a new dossier share link.
    #
    # @param ttl [ActiveSupport::Duration] the time to live for the new link
    # @param locale [String] the user frontend locale
    # @param args [Hash{Symbol => Mixed}] additional options
    # @return [String] the new dossier frontend link
    def link(ttl: 365.days, locale: 'de_CH', lang: 'de', **args)
      # Make sure the current dossier is saved before we try to generate a link
      return unless save(**args)

      # Send a "share dossier" request to the service
      url = client.share_dossier(self, ttl: ttl, locale: locale, **args)
      url += "?lang=#{lang}" if url
      url
    end

    # Generate bang method variants
    bangers :save, :link, :delete, :destroy
  end
end
