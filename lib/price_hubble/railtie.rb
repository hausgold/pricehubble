# frozen_string_literal: true

module PriceHubble
  # Rails-specific initializations.
  class Railtie < Rails::Railtie
    # Run before all Rails initializers, but after the application is defined
    config.before_initialize do
      # Nothing to do here at the moment.
    end

    # Run after all configuration is set via Rails initializers
    config.after_initialize do
      # Nothing to do here at the moment.
    end
  end
end
