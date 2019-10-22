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
require 'pp'

# Load polyfills if needed
require 'pricehubble/core_ext/hash'

# The top level namespace for the PriceHubble gem.
module PriceHubble
  # Top level elements
  autoload :Configuration, 'pricehubble/configuration'
  autoload :ConfigurationHandling, 'pricehubble/configuration_handling'
  autoload :Client, 'pricehubble/client'
  autoload :Identity, 'pricehubble/identity'
  autoload :Instrumentation, 'pricehubble/instrumentation'

  # Entities
  autoload :BaseEntity, 'pricehubble/entity/base_entity'
  autoload :Authentication, 'pricehubble/entity/authentication'
  autoload :Valuation, 'pricehubble/entity/valuation'
  autoload :ValuationScores, 'pricehubble/entity/valuation_scores'
  autoload :ValuationRequest, 'pricehubble/entity/valuation_request'
  autoload :Property, 'pricehubble/entity/property'
  autoload :PropertyConditions, 'pricehubble/entity/property_conditions'
  autoload :PropertyQualities, 'pricehubble/entity/property_qualities'
  autoload :PropertyType, 'pricehubble/entity/property_type'
  autoload :Location, 'pricehubble/entity/location'
  autoload :Address, 'pricehubble/entity/address'
  autoload :Coordinates, 'pricehubble/entity/coordinates'

  # Some general purpose utilities
  module Utils
    autoload :Decision, 'pricehubble/utils/decision'
    autoload :Bangers, 'pricehubble/utils/bangers'
  end

  # Instrumentation
  module Instrumentation
    autoload :LogSubscriber, 'pricehubble/instrumentation/log_subscriber'
  end

  # Dedicated application HTTP (low level) client
  module Client
    # All our utilities used for the low level client
    module Utils
      autoload :Request, 'pricehubble/client/utils/request'
      autoload :Response, 'pricehubble/client/utils/response'
    end

    # Faraday request middlewares
    module Request
      autoload :DataSanitization, 'pricehubble/client/request/data_sanitization'
      autoload :DefaultHeaders, 'pricehubble/client/request/default_headers'
    end

    # Faraday response middlewares
    module Response
      autoload :DataSanitization,
               'pricehubble/client/response/data_sanitization'
      autoload :RecursiveOpenStruct,
               'pricehubble/client/response/recursive_open_struct'
    end

    autoload :Base, 'pricehubble/client/base'
    autoload :Authentication, 'pricehubble/client/authentication'
    autoload :Valuation, 'pricehubble/client/valuation'
  end

  # Separated features of an entity instance
  module EntityConcern
    autoload :Callbacks, 'pricehubble/entity/concern/callbacks'
    autoload :Attributes, 'pricehubble/entity/concern/attributes'
    autoload :Associations, 'pricehubble/entity/concern/associations'
    autoload :Client, 'pricehubble/entity/concern/client'

    # Some custom typed attribute helpers
    module Attributes
      base = 'pricehubble/entity/concern/attributes'
      autoload :DateArray, "#{base}/date_array"
      autoload :Enum, "#{base}/enum"
      autoload :Range, "#{base}/range"
      autoload :StringInquirer, "#{base}/string_inquirer"
    end
  end

  # Load standalone code
  require 'pricehubble/version'
  require 'pricehubble/errors'
  require 'pricehubble/faraday'
  require 'pricehubble/railtie' if defined? Rails

  # Include top-level features
  include PriceHubble::ConfigurationHandling
  include PriceHubble::Client
  include PriceHubble::Identity
  include PriceHubble::Instrumentation
end
