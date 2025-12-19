# frozen_string_literal: true

module PriceHubble
  # A bunch of top-level client helpers.
  module Client
    extend ActiveSupport::Concern

    class_methods do
      # Get a low level client for the requested application. This returns an
      # already instantiated client object, ready to use.
      #
      # @param name [Symbol, String] the client name
      # @return [PriceHubble::Client::Base] a compatible client instance
      def client(name)
        name
          .to_s
          .underscore
          .camelize
          .prepend('PriceHubble::Client::')
          .constantize
          .new
      end
    end
  end
end
