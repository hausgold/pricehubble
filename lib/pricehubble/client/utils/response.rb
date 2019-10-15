# frozen_string_literal: true

module PriceHubble
  module Client
    module Utils
      # Some helpers to work with responses in a general way.
      module Response
        extend ActiveSupport::Concern

        included do
          # Simple helper to query the response status.
          #
          # @param res [Faraday::response] the response object
          # @param code [Range, Array, Integer] the range of good
          #   response codes
          # @return [Boolean] whenever the request got an allowed status
          def status?(res, code: 0..399)
            code = [code] unless code.is_a? Range
            code = code.flatten if code.is_a? Array
            code.include? res.status
          end
          alias_method :successful?, :status?

          # A simple syntactic sugar helper to query the response status.
          #
          # @param res [Faraday::response] the response object
          # @param code [Range] the range of failed response codes
          # @return [Boolean] whenever the request failed
          def failed?(res, code: 400..600)
            status?(res, code: code)
          end

          # Perform a common error handling for entity responses. This allows a
          # clean usage of the decision flow control. Here comes an example:
          #
          #   decision do |result|
          #     result.bang(&bang_entity(entity, res, id: entity.id))
          #   end
          #
          # @param entity [PriceHubble::BaseEntity, Class] the result entity
          # @param res [Faraday::Response] the response object
          # @param data [Hash{Mixed => Mixed}] the request data
          # @return [Proc] the proc which performs the error handling
          def bang_entity(entity, res, data)
            class_name = entity
            class_name = entity.class unless entity.is_a? Class
            lambda do
              next PriceHubble::EntityNotFound.new(nil, class_name, data) \
                if res.status == 404
              next PriceHubble::EntityInvalid.new(res.body.message, entity) \
                if res.status == 400

              PriceHubble::RequestError.new(nil, res)
            end
          end
        end
      end
    end
  end
end
