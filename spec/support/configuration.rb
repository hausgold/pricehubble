# frozen_string_literal: true

# rubocop:disable Style/GlobalVars just for the RSpec test suite
$yelled = false

# Set the gem configuration according to the test suite.
#
# rubocop:disable Metrics/MethodLength because of the extra warnings
# rubocop:disable Metrics/AbcSize because of the credentials handling
def reset_test_configuration!
  PriceHubble.reset_configuration!
  PriceHubble.reset_identity!
  PriceHubble.configure do |conf|
    conf.logger = Logger.new(IO::NULL)
    conf.username ||= '<USERNAME>'
    conf.password ||= '<PASSWORD>'

    next if $yelled

    warnings = false

    if ENV['PRICEHUBBLE_USERNAME'].nil?
      warnings = true
      puts '[WARN] The environment variable `PRICEHUBBLE_USERNAME` is unset.'
    end

    if ENV['PRICEHUBBLE_PASSWORD'].nil?
      warnings = true
      puts '[WARN] The environment variable `PRICEHUBBLE_PASSWORD` is unset.'
    end

    if warnings
      puts '[WARN] You cannot record new VCR cassettes without '
      puts '[WARN] working credentials.'
      puts
    end

    $yelled = true
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
# rubocop:enable Style/GlobalVars
