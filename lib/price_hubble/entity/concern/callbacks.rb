# frozen_string_literal: true

module PriceHubble
  module Concern
    # Define all the base callbacks of a common entity.
    module Callbacks
      extend ActiveSupport::Concern

      class_methods do
        include ActiveModel::Callbacks
      end

      included do
        # Define all the base callbacks
        define_model_callbacks :initialize, only: :after
      end
    end
  end
end
