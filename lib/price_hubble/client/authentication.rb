# frozen_string_literal: true

module PriceHubble
  module Client
    # A high level client library for the PriceHubble Authentication API.
    class Authentication < Base
      # Perform a login request while sending the passed credentials.
      #
      # @param args [Hash{Symbol => Mixed}] the authentication credentials
      # @return [PriceHubble::Authentication, nil] the authentication entity,
      #   or +nil+ on error
      def login(**args)
        res = connection.post do |req|
          req.path = '/auth/login/credentials'
          req.body = args.except(:bang)
          use_default_context(req, :login)
        end
        decision(bang: args.fetch(:bang, false)) do |result|
          result.bang { PriceHubble::AuthenticationError.new(nil, res) }
          result.good { PriceHubble::Authentication.new(res.body) }
          successful?(res)
        end
      end

      # Generate bang method variants
      bangers :login
    end
  end
end
