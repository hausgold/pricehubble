# frozen_string_literal: true

require 'bundler/setup'
require 'pricehubble'

PriceHubble.reset_configuration!
PriceHubble.configure do |conf|
  # conf.request_logging = true
end

errors = false

if ENV['PRICEHUBBLE_USERNAME'].blank?
  errors = true
  puts '> [ERR] Environment variable `PRICEHUBBLE_USERNAME` is missing.'
end

if ENV['PRICEHUBBLE_PASSWORD'].blank?
  errors = true
  puts '> [ERR] Environment variable `PRICEHUBBLE_PASSWORD` is missing.'
end

if errors
  puts
  puts '> Usage:'
  puts ">   $ export PRICEHUBBLE_USERNAME='your-username'"
  puts ">   $ export PRICEHUBBLE_PASSWORD='your-password'"
  puts ">   $ #{$PROGRAM_NAME} #{ARGV.join(' ')}"
  exit
end
