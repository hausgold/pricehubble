# frozen_string_literal: true

module PriceHubble
  module Client
    # A high level client library for the PriceHubble Valuation API.
    class Valuation < Base
      # Perform a full-fledged valuation request.
      #
      # @param request [PriceHubble::ValuationRequest] the valuation request
      # @param args [Hash{Symbol => Mixed}] the authentication credentials
      # @return [Array<PriceHubble::Valuation>, nil] the valuation results,
      #   or +nil+ on error
      #
      # rubocop:disable Metrics/MethodLength -- because of the request handling
      # rubocop:disable Metrics/AbcSize -- ditto
      def property_value(request, **args)
        data = request.attributes(sanitize: true)
        res = connection.post do |req|
          req.path = '/api/v1/valuation/property_value'
          req.body = data
          use_default_context(req, :property_value)
          use_authentication(req)
        end
        decision(bang: args.fetch(:bang, false)) do |result|
          result.bang(&bang_entity(request, res, data))
          result.good(&assign_valuations(res.body.valuations, request))
          successful?(res)
        end
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      # Map and assign the valuation response to our local
      # +PriceHubble::Valuation+ representation. While taking care of the
      # multi-dimensional array structure which is reflected from the request
      # data. You get back a lambda which you need to call to get the results
      # (for use in a decision). The return values is a
      # +Array<PriceHubble::Valuation>+.
      #
      # @param data [Array<Array<RecursiveOpenStruct>>] the raw response
      #   valuations data
      # @param request [PriceHubble::ValuationRequest] the original request
      # @return [Proc] the valuation mapping code
      #
      # rubocop:disable Metrics/MethodLength -- because of the request to
      #   response mapping
      # rubocop:disable Metrics/AbcSize -- ditto
      def assign_valuations(data, request)
        lambda do
          # valuations[i][j] contains the valuation for property i on date j
          data.each_with_index.map do |valuations, property_idx|
            valuations.each_with_index.map do |valuation, date_idx|
              # Fetch the request data for this valuation and
              # extend the raw data to build a local representation
              valuation.property = request.properties[property_idx]
              valuation.valuation_date = request.valuation_dates[date_idx]
              valuation.deal_type = request.deal_type
              valuation.country_code = request.country_code
              # Build the local representation from the raw data
              PriceHubble::Valuation.new(valuation)
            end
          end.flatten
        end
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      # Generate bang method variants
      bangers :property_value
    end
  end
end
