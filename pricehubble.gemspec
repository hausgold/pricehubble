# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pricehubble/version'

Gem::Specification.new do |spec|
  spec.name          = 'pricehubble'
  spec.version       = PriceHubble::VERSION
  spec.authors       = ['Hermann Mayer']
  spec.email         = ['hermann.mayer92@gmail.com']

  spec.summary       = 'Ruby client for the PriceHubble REST API'
  spec.description   = 'Ruby client for the PriceHubble REST API'
  spec.homepage      = 'https://github.com/hausgold/pricehubble'

  spec.required_ruby_version = '~> 2.5'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activemodel', '>= 5.2.0'
  spec.add_runtime_dependency 'activesupport', '>= 5.2.0'
  spec.add_runtime_dependency 'faraday', '~> 1.0'
  spec.add_runtime_dependency 'faraday_middleware', '~> 1.0'
  spec.add_runtime_dependency 'recursive-open-struct', '~> 1.1'

  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'bundler', '>= 1.16', '< 3'
  spec.add_development_dependency 'factory_bot', '~> 4.11'
  spec.add_development_dependency 'railties', '>= 4.2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rdoc', '~> 6.1'
  spec.add_development_dependency 'redcarpet', '~> 3.4'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.63.1'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.31'
  spec.add_development_dependency 'simplecov', '~> 0.15'
  spec.add_development_dependency 'terminal-table', '~> 1.8'
  spec.add_development_dependency 'timecop', '~> 0.9.1'
  spec.add_development_dependency 'vcr', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 3.5'
  spec.add_development_dependency 'yard', '~> 0.9.18'
  spec.add_development_dependency 'yard-activesupport-concern', '~> 0.0.1'
end
