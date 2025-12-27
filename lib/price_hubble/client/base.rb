# frozen_string_literal: true

module PriceHubble
  module Client
    # The base API client class definition. It bundles all the separated
    # application logic on a low level.
    class Base
      include PriceHubble::Client::Utils::Request
      include PriceHubble::Client::Utils::Response
      include PriceHubble::Utils::Decision
      include PriceHubble::Utils::Bangers

      # Configure the connection instance in a generic manner. Each client can
      # modify the connection in a specific way, when the application requires
      # special handling. Just overwrite the +configure+ method, and call
      # +super(con)+. Here is a full example:
      #
      #   def configure(con)
      #     super(con)
      #     con.request :url_encoded
      #     con.response :logger
      #     con.adapter Faraday.default_adapter
      #   end
      #
      # @param con [Faraday::Connection] the connection object
      def configure(con)
        # The definition order is execution order
        con.request :instrumentation
        con.request :ph_data_sanitization
        con.request :ph_default_headers
        con.request :json
        con.request :multipart
        con.request :url_encoded

        # The definition order is reverse to the execution order
        con.response :ph_recursive_open_struct
        con.response :ph_data_sanitization
        con.response :parse_dates
        con.response :json, content_type: /\bjson$/
        con.response :follow_redirects

        con.adapter Faraday.default_adapter
      end

      # Create a new Faraday connection on the first shot, and pass the cached
      # connection object on subsequent calls.
      #
      # @return [Faraday::Connection] the connection object
      def connection
        @connection ||= Faraday.new(url: PriceHubble.configuration.base_url,
                                    &method(:configure))
      end
    end
  end
end
