# frozen_string_literal: true

require 'vcr'

unless ENV.fetch('VCR', 'true') == 'false'
  VCR.configure do |conf|
    conf.cassette_library_dir = 'spec/fixtures/cassettes'
    conf.hook_into :webmock

    # Take care of PriceHubble sensitives
    conf.filter_sensitive_data('<USERNAME>') do
      PriceHubble.configuration.username
    end
    conf.filter_sensitive_data('<PASSWORD>') do
      PriceHubble.configuration.password
    end

    token = '0' * 32

    # We do not want to save access tokens on response bodies
    conf.before_record do |interaction|
      replacement = %("access_token": "#{token}")
      interaction.response.body.gsub!(/"access_token": "[^"]+"/, replacement)
    end

    # We do not want to save access tokens on request URIs
    conf.before_record do |interaction|
      replacement = "access_token=#{token}"
      interaction.request.uri.gsub!(/access_token=[^&]+/, replacement)
    end
  end
end

# We use our own VCR/RSpec metadata handler which allows us to be dynamic out
# of the box, but also to reuse costly recorded cassettes. With this helper you
# can easily reuse the same cassette for multiple examples, contexts and
# descriptions.
#
#   describe '#perform!', vcr: cassette(:valuation_request) do
#     # ...
#   end
#
# @param names [Array<String, Symbol>] the relative cassette name
# @param args [Hash{Symbol => Mixed}] additional VCR options
# @return [Hash{Symbol}] the cassette options hash
def cassette(*names, **args)
  {
    name: "price_hubble/#{names.map(&:to_s).join('/')}"
  }.merge(args)
end
