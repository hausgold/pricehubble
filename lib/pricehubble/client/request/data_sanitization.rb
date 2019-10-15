# frozen_string_literal: true

module PriceHubble
  module Client
    module Request
      # We like snake cased attributes here, but the API requires camel cased
      # hash keys, so we take care of it in a generic way here. Furthermore, we
      # perform a deep compaction of the given body hash, to strip +nil+ values
      # and empty hashes from the request. There is no need to send null-data
      # on a round trip.
      class DataSanitization < Faraday::Middleware
        # Serve the Faraday middleware API.
        #
        # @param env [Hash{Symbol => Mixed}] the request
        def call(env)
          body = env[:body]

          # Perform the data compaction and the hash key transformation,
          # when the body is available and a hash
          env[:body] = body.deep_compact.deep_camelize_keys \
            if body&.is_a?(Hash)

          @app.call(env)
        end
      end
    end
  end
end
