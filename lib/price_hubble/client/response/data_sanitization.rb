# frozen_string_literal: true

module PriceHubble
  module Client
    module Response
      # We like snake cased attributes here, but the API sends camel cased
      # hash keys on responses, so we take care of it in a generic way here.
      class DataSanitization < Faraday::Middleware
        # Serve the Faraday middleware API.
        #
        # @param env [Hash{Symbol => Mixed}] the request
        def call(env)
          @app.call(env).on_complete do |res|
            body = res[:body]

            # Skip string bodies, they are unparsed or contain binary data
            next if body.is_a? String

            # Skip non-hash bodies, we cannot handle them here
            next unless body.is_a? Hash

            # Perform the key transformation
            res[:body] = body.deep_underscore_keys
          end
        end
      end
    end
  end
end
