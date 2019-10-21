# frozen_string_literal: true

module PriceHubble
  # Some instrumentation and logging facility helpers.
  module Instrumentation
    extend ActiveSupport::Concern

    included do
      # Add the log subscriber to the faraday namespace
      PriceHubble::Instrumentation::LogSubscriber.attach_to :faraday
    end
  end
end
