# frozen_string_literal: true

module PriceHubble
  module Client
    module Request
      # Add some default headers to every request.
      class DefaultHeaders < Faraday::Middleware
        # Serve the Faraday middleware API.
        #
        # @param env [Hash{Symbol => Mixed}] the request
        def call(env)
          env[:request_headers].merge! \
            'User-Agent' => user_agent,
            'Accept' => 'application/json'

          # Set request content type to JSON as fallback
          env[:request_headers]['Content-Type'] = 'application/json' \
            if env[:request_headers]['Content-Type'].blank?

          @app.call(env)
        end

        # Build an useful user agent string to pass. We identify ourself as
        # +PriceHubbleGem+ with the current gem version.
        #
        # @return [String] the user agent string
        def user_agent
          "PriceHubbleGem/#{PriceHubble::VERSION}"
        end
      end
    end
  end
end
