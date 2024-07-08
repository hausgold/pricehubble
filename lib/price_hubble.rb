# frozen_string_literal: true

require 'active_support'
require 'active_support/concern'
require 'active_support/configurable'
require 'active_support/time'
require 'active_support/time_with_zone'
require 'active_support/core_ext/object'
require 'active_support/core_ext/module'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'
require 'active_model'
require 'recursive-open-struct'
require 'faraday'
require 'faraday_middleware'

# Load polyfills if needed
require 'price_hubble/core_ext/hash'

# The top level namespace for the PriceHubble gem.
module PriceHubble
  # Top level elements
  autoload :Configuration, 'price_hubble/configuration'
  autoload :ConfigurationHandling, 'price_hubble/configuration_handling'
  autoload :Client, 'price_hubble/client'
  autoload :Identity, 'price_hubble/identity'
  autoload :Instrumentation, 'price_hubble/instrumentation'

  # Entities
  autoload :BaseEntity, 'price_hubble/entity/base_entity'
  autoload :Authentication, 'price_hubble/entity/authentication'
  autoload :Valuation, 'price_hubble/entity/valuation'
  autoload :ValuationScores, 'price_hubble/entity/valuation_scores'
  autoload :ValuationRequest, 'price_hubble/entity/valuation_request'
  autoload :Property, 'price_hubble/entity/property'
  autoload :PropertyConditions, 'price_hubble/entity/property_conditions'
  autoload :PropertyQualities, 'price_hubble/entity/property_qualities'
  autoload :PropertyType, 'price_hubble/entity/property_type'
  autoload :Location, 'price_hubble/entity/location'
  autoload :Address, 'price_hubble/entity/address'
  autoload :Coordinates, 'price_hubble/entity/coordinates'
  autoload :Dossier, 'price_hubble/entity/dossier'

  # Some general purpose utilities
  module Utils
    autoload :Decision, 'price_hubble/utils/decision'
    autoload :Bangers, 'price_hubble/utils/bangers'
  end

  # Instrumentation
  module Instrumentation
    autoload :LogSubscriber, 'price_hubble/instrumentation/log_subscriber'
  end

  # Dedicated application HTTP (low level) client
  module Client
    # All our utilities used for the low level client
    module Utils
      autoload :Request, 'price_hubble/client/utils/request'
      autoload :Response, 'price_hubble/client/utils/response'
    end

    # Faraday request middlewares
    module Request
      autoload :DataSanitization,
               'price_hubble/client/request/data_sanitization'
      autoload :DefaultHeaders, 'price_hubble/client/request/default_headers'
    end

    # Faraday response middlewares
    module Response
      autoload :DataSanitization,
               'price_hubble/client/response/data_sanitization'
      autoload :RecursiveOpenStruct,
               'price_hubble/client/response/recursive_open_struct'
    end

    autoload :Base, 'price_hubble/client/base'
    autoload :Authentication, 'price_hubble/client/authentication'
    autoload :Valuation, 'price_hubble/client/valuation'
    autoload :Dossiers, 'price_hubble/client/dossiers'
  end

  # Separated features of an entity instance
  module EntityConcern
    autoload :Callbacks, 'price_hubble/entity/concern/callbacks'
    autoload :Attributes, 'price_hubble/entity/concern/attributes'
    autoload :Associations, 'price_hubble/entity/concern/associations'
    autoload :Client, 'price_hubble/entity/concern/client'
    autoload :Persistence, 'price_hubble/entity/concern/persistence'

    # Some custom typed attribute helpers
    module Attributes
      base = 'price_hubble/entity/concern/attributes'
      autoload :DateArray, "#{base}/date_array"
      autoload :Enum, "#{base}/enum"
      autoload :Range, "#{base}/range"
      autoload :StringInquirer, "#{base}/string_inquirer"
    end
  end

  # Load standalone code
  require 'price_hubble/version'
  require 'price_hubble/errors'
  require 'price_hubble/faraday'
  require 'price_hubble/railtie' if defined? Rails

  # Include top-level features
  include PriceHubble::ConfigurationHandling
  include PriceHubble::Client
  include PriceHubble::Identity
  include PriceHubble::Instrumentation
end
