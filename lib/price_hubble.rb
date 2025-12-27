# frozen_string_literal: true

require 'zeitwerk'
require 'logger'
require 'active_support'
require 'active_support/concern'
require 'active_support/ordered_options'
require 'active_support/time'
require 'active_support/time_with_zone'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/object'
require 'active_support/core_ext/module'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'
require 'active_model'
require 'recursive-open-struct'
require 'faraday'
require 'faraday/multipart'
require 'faraday/follow_redirects'
require 'faraday/parse_dates'

# The top level namespace for the PriceHubble gem.
module PriceHubble
  # Configure the relative gem code base location
  root_path = Pathname.new("#{__dir__}/price_hubble")

  # Setup a Zeitwerk autoloader instance and configure it
  loader = Zeitwerk::Loader.for_gem

  # Do not auto load some parts of the gem
  loader.ignore("#{__dir__}/pricehubble*")
  loader.ignore(root_path.join('core_ext'))
  loader.ignore(root_path.join('initializers*'))
  loader.ignore(root_path.join('railtie.rb'))

  # Entity definitions, based on core functionalities,
  # all entities are directly located at the namespace root,
  # together with their shared concerns
  loader.push_dir(root_path.join('entity'), namespace: PriceHubble)

  # Finish the auto loader configuration
  loader.setup

  # Load standalone code
  require 'price_hubble/version'
  require 'price_hubble/railtie' if defined? Rails

  # Load all core extension of the gem
  Dir[root_path.join('core_ext/**/*.rb')].each { |path| require path }

  # Load all initializers of the gem
  Dir[root_path.join('initializers/**/*.rb')].each { |path| require path }

  # Include top-level features
  include PriceHubble::ConfigurationHandling
  include PriceHubble::Client
  include PriceHubble::Identity
  include PriceHubble::Instrumentation

  # Make sure to eager load all constants
  loader.eager_load
end
