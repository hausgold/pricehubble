# frozen_string_literal: true

module PriceHubble
  module Client
    module Response
      # Convert every response body to an +RecursiveOpenStruct+ for an easy
      # access.
      class RecursiveOpenStruct < Faraday::Middleware
        # Serve the Faraday middleware API.
        #
        # @param env [Hash{Symbol => Mixed}] the request
        def call(env)
          @app.call(env).on_complete do |res|
            body = res[:body]

            # Skip string bodies, they are unparsed or contain binary data
            next if body.is_a? String

            # By definition empty responses (HTTP status 204)
            # or actual empty bodies should be an empty hash
            body = {} if res[:status] == 204 || res[:body].blank?

            # Looks like we have some actual data we can wrap
            res[:body] = \
              ::RecursiveOpenStruct.new(body, recurse_over_arrays: true)
          end
        end
      end
    end
  end
end
