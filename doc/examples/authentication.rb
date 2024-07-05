#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'config'

# Fetch the authentication/identity for the first time, subsequent calls
# to this method will return the cached authentication instance until it
# is expired (or near expiration, 5 minutes leeway) then a new
# authentication is fetched transparently
pp PriceHubble.identity
# => #<PriceHubble::Authentication access_token="...", ...>

# Check the expiration state (transparently always unexpired)
pp PriceHubble.identity.expired?
# => false

# Get the current authentication expiration date/time
pp PriceHubble.identity.expires_at
# => 2019-10-17 08:01:23 +0000
