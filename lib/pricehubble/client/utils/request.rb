# frozen_string_literal: true

module PriceHubble
  module Client
    module Utils
      # Some helpers to prepare requests in a general way.
      #
      module Request
        extend ActiveSupport::Concern

        included do
          # A common HTTP content type to symbol
          # mapping for correct header settings.
          CONTENT_TYPE = {
            json: 'application/json',
            multipart: 'multipart/form-data',
            url_encoded: 'application/x-www-form-urlencoded'
          }.freeze

          # Use the configured identity to authenticate the given request.
          #
          # @param req [Faraday::Request] the request to manipulate
          def use_authentication(req)
            req.params.merge!(access_token: PriceHubble.identity.access_token)
          end

          # Use the default request context to identificate the request.
          #
          # @param action [String, Symbol] the used client action
          # @param req [Faraday::Request] the request to manipulate
          def use_default_context(req, action)
            req.options.context ||= {}
            req.options.context.merge!(client: self.class,
                                       action: action,
                                       request_id: SecureRandom.hex(3))
          end
        end
      end
    end
  end
end
