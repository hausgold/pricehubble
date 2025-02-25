# frozen_string_literal: true

module PriceHubble
  module Client
    # A high level client library for the PriceHubble Dossiers API.
    class Dossiers < Base
      # Create a new dossier.
      #
      # @param entity [PriceHubble::Dossier] the entity to use
      # @param args [Hash{Symbol => Mixed}] additional arguments
      # @return [PriceHubble::Dossier, nil] the PriceHubble dossier,
      #   or +nil+ on error
      #
      # rubocop:disable Metrics/MethodLength -- because thats the bare minimum
      #   handling is quite complex
      def create_dossier(entity, **args)
        res = connection.post do |req|
          req.path = '/api/v1/dossiers'
          req.body = entity.attributes.compact
          use_default_context(req, :create_dossier)
          use_authentication(req)
        end
        decision(bang: args.fetch(:bang, false)) do |result|
          result.bang(&bang_entity(entity, res, {}))
          result.good(&assign_entity(entity, res))
          successful?(res)
        end
      end
      # rubocop:enable Metrics/MethodLength

      # Generates a permalink for the specified dossier which will expire after
      # the set number of days.
      #
      # @param entity [PriceHubble::Dossier] the entity to use
      # @param ttl [ActiveSupport::Duration] the time to live for the new link
      # @param locale [String] the user frontend locale
      # @param args [Hash{Symbol => Mixed}] additional arguments
      #
      # rubocop:disable Metrics/MethodLength -- because thats the bare minimum
      # rubocop:disable Metrics/AbcSize -- because the decission handling is
      #   quite complex
      def share_dossier(entity, ttl:, locale:, **args)
        res = connection.post do |req|
          req.path = '/api/v1/dossiers/links'
          req.body = {
            dossier_id: entity.id,
            days_to_live: ttl.fdiv(1.day.to_i).ceil,
            country_code: entity.country_code,
            locale: locale
          }
          use_default_context(req, :share_dossier)
          use_authentication(req)
        end
        decision(bang: args.fetch(:bang, false)) do |result|
          result.bang(&bang_entity(entity, res, id: entity.try(:id)))
          result.good { res.body.url }
          successful?(res)
        end
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      # Delete a dossier entity.
      #
      # @param entity [PriceHubble::Dossier] the entity to delete
      # @param args [Hash{Symbol => Mixed}] additional arguments
      #
      # rubocop:disable Metrics/MethodLength -- because thats the bare
      #   minimumbecause the decission handling is quite complex
      def delete_dossier(entity, **args)
        res = connection.delete do |req|
          req.path = "/api/v1/dossiers/#{entity.id}"
          use_default_context(req, :delete_dossier)
          use_authentication(req)
        end
        decision(bang: args.fetch(:bang, false)) do |result|
          result.bang(&bang_entity(entity, res, id: entity.id))
          result.good(&assign_entity(entity, res) do |assigned_entity|
            assigned_entity.mark_as_destroyed.freeze
          end)
          successful?(res)
        end
      end

      # rubocop:enable Metrics/MethodLength
      # Update a dossier entity.
      #
      # TODO: Implement this.
      #
      # @param entity [PriceHubble::Dossier] the entity to update
      # @param args [Hash{Symbol => Mixed}] additional arguments
      # @return [PriceHubble::Dossier, nil] the entity, or +nil+ on error
      def update_dossier(*)
        # PUT dossiers/<dossier_id>
        raise NotImplementedError
      end

      # Search for dossier entities.
      #
      # TODO: Implement this.
      #
      # @param criteria [Mixed] the search criteria
      # @param args [Hash{Symbol => Mixed}] additional arguments
      # @return [Array<PriceHubble::Dossier>, nil] the entity,
      #   or +nil+ on error
      def search_dossiers(*)
        # POST dossiers/search
        raise NotImplementedError
      end

      # Generate bang method variants
      bangers :create_dossier, :update_dossier, :delete_dossier,
              :share_dossier, :search_dossiers
    end
  end
end
