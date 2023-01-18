# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'countless/rake_tasks'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

# Configure all code statistics directories
Countless.configure do |config|
  config.stats_base_directories = [
    { name: 'Top-levels', dir: 'lib',
      pattern: %r{/lib(/pricehubble)?/[^/]+\.rb$} },
    { name: 'Top-levels specs', test: true, dir: 'spec',
      pattern: %r{/spec(/pricehubble)?/[^/]+_spec\.rb$} },
    { name: 'Clients', pattern: 'lib/pricehubble/client/**/*.rb' },
    { name: 'Clients specs', test: true,
      pattern: 'spec/client/**/*_spec.rb' },
    { name: 'Entities', pattern: 'lib/pricehubble/entity/**/*.rb' },
    { name: 'Entities specs', test: true,
      pattern: 'spec/entity/**/*_spec.rb' },
    { name: 'Utilities', pattern: 'lib/pricehubble/utils/**/*.rb' },
    { name: 'Utilities specs', test: true,
      pattern: 'spec/utils/**/*_spec.rb' },
    { name: 'Instrumentation',
      pattern: 'lib/pricehubble/instrumentation/**/*.rb' },
    { name: 'Core Extensions', pattern: 'lib/pricehubble/core_ext/**/*.rb' }
  ]
end
