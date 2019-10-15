![PriceHubble](doc/assets/project.svg)

[![Build Status](https://travis-ci.com/hausgold/pricehubble.svg?token=4XcyqxxmkyBSSV3wWRt7&branch=master)](https://travis-ci.com/hausgold/pricehubble)
[![Gem Version](https://badge.fury.io/rb/pricehubble.svg)](https://badge.fury.io/rb/pricehubble)
[![Maintainability](https://api.codeclimate.com/v1/badges/cd15f59fc84566e4b200/maintainability)](https://codeclimate.com/repos/5da572bd60163201b800c255/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/cd15f59fc84566e4b200/test_coverage)](https://codeclimate.com/repos/5da572bd60163201b800c255/test_coverage)
[![API docs](https://img.shields.io/badge/docs-API-blue.svg)](https://www.rubydoc.info/gems/pricehubble)

This project is dedicated to build a client/API wrapper around the
[PriceHubble](https://pricehubble.com) REST API. It follows strictly the
[version 1 of the API specification](https://docs.pricehubble.com). Furthermore
this gem allows you to easily interact with common PriceHubble operations like
fetching property valuations. At the time of writing it supports not the full
API specification, but it should be easy to enhance the client functionality,
so feel free to send a pull request.

- [Installation](#installation)
- [Usage](#usage)
  - [Configuration](#configuration)
    - [Available environment variables](#available-environment-variables)
  - [Authentication](#authentication)
  - [Error Handling](#error-handling)
  - [Property Valuations](#property-valuations)
    - [Bare Minimum Request Example](#bare-minimum-request-example)
    - [Use the PriceHubble::Valuation representation](#use-the-pricehubblevaluation-representation)
    - [Error Handling](#error-handling-1)
    - [Advanced Request Examples](#advanced-request-examples)
- [Development](#development)
- [Contributing](#contributing)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pricehubble'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install pricehubble
```

## Usage

### Configuration

You can configure the pricehubble gem via an Rails initializer, by environment
variables or on demand. Here we show a common Rails initializer example:

```ruby
PriceHubble.configure do |conf|
  # Configure the API authentication credentials
  conf.username = 'your-username'
  conf.password = 'your-password'

  # The base URL of the API (there is no staging/canary
  # endpoint we know about)
  conf.base_url = 'https://api.pricehubble.com'

  # Writes to stdout by default
  conf.logger = Logger.new(IO::NULL)
end
```

The pricehubble gem comes with sensitive defaults as you can see. For most
users an extra configuration, beside the authorization credentials, is not
needed.

#### Available environment variables

The pricehubble gem can be configured hardly with its configuration code block
like shown before. Respecting the [twelve-factor app](https://12factor.net/)
concerns, the gem allows you to set almost all configurations (just the
relevant ones for runtime) via environment variables. Here comes a list of
available configuration options:

* **PRICEHUBBLE_USERNAME**: The API username to use for authentication.
* **PRICEHUBBLE_PASSWORD**: The API password to use for authentication.
* **PRICEHUBBLE_BASE_URL**: The base URL of the API. Defaults to the production one.

### Authentication

After configuring the pricehubble gem you can directly fetch an
authentication which is valid for two hours. All operational requests
require an authentication to be present and unexpired. But now comes
the good part: you don't ever need to take care about this, because
the gem handles the refreshing of the authentication transparently for
you and also takes care of passing the authentication to each request
you can do with the gem.

```ruby
# Fetch the authentication/identity for the first time, subsequent calls
# to this method will return the cached authentication instance until it
# is expired (or near expiration, 5 minutes leeway) then a new
# authentication is fetched transparently
PriceHubble.identity
# => #<PriceHubble::Authentication access_token="...", ...>

# Check the expiration state (transparently always unexpired)
PriceHubble.identity.expired?
# => false

# Get the current authentication expiration date/time
PriceHubble.identity.expires_at
# => 2019-10-17 08:01:23 +0000
```

### Error Handling

The pricehubble gem allows you to decide how to react on errors on a
per-request basis. (except the transparent authentication) All request
performing methods are shiped in a bang and non-bang variant.

The bang variants (eg. `PriceHubble::ValuationRequest#perform!`, mind
the exclamation mark at the end) will raise an child instance of the
`PriceHubble::RequestError` or `PriceHubble::EntityError` class ([see
errors for more details](lib/pricehubble/errors.rb)) when errors
occur. This comes in handy on asynchronous jobs which are retried on
exceptions.

The non-bang variants (eg. `PriceHubble::ValuationRequest#perform`,
without the exclamation mark) wont raise and just return empty results
(eg. `false` or `[]`). This might me comfortable in complex control
flows or when you do not care if one out of 100 times the data is
missing. But watch out for bad/invalid requests you might mask with
this behaviour.

It's up to you to choose the correct flavor for your usecase.

### Property Valuations

The pricehubble gem allows you to request property valuations easily.
You can formulate your request elegantly with in-place attribute sets
or already built instances the same way. Furthermore the gem ships
some sensible defaults which makes it even more easy to get an
valuation for a property.

The `PriceHubble::ValuationRequest` allows to fetch valuations for one
or more (bulk) properties at once for one or several dates. The upper
limit for this is `properties.count * dates.count <= 50` from API
side.

**Gotcha!** The API allows to fetch property valuations with
per-property independent time series. The pricehubble gem does not
support this for the sake of ease.

#### Bare Minimum Request Example

```ruby
# Fetch the valuations for a single property (sale) for today (defaults).
# This is the bare minimum variant, as a starting point.
valuations = PriceHubble::ValuationRequest.new(
  property: {
    location: {
      address: {
        post_code: '22769',
        city: 'Hamburg',
        street: 'Stresemannstr.',
        house_number: '29'
      }
    },
    property_type: { code: :apartment },
    building_year: 1990,
    living_area: 200
  }
).perform!
# => [#<PriceHubble::Valuation ...>]

# Print all relevant valuation attributes
pp valuations.first.attributes.deep_compact
# => {"currency"=>"EUR",
# =>  "sale_price"=>1283400,
# =>  "sale_price_range"=>1180800..1386100,
# =>  "confidence"=>"good",
# =>  "deal_type"=>"sale",
# =>  "valuation_date"=>Thu, 17 Oct 2019,
# =>  "country_code"=>"DE",
# =>  "property"=>
# =>   {"location"=>
# =>     {"address"=>
# =>       {"post_code"=>"22769",
# =>        "city"=>"Hamburg",
# =>        "street"=>"Stresemannstr.",
# =>        "house_number"=>"29"}},
# =>    "property_type"=>{"code"=>:apartment},
# =>    "building_year"=>1990,
# =>    "living_area"=>200}}
```

#### Use the PriceHubble::Valuation representation

The [`PriceHubble::Valuation`](lib/pricehubble/entity/valuation.rb)
representation ships a lot utilities and helpers to process the data.
Here are some examples:

```ruby
# Fetch the valuations
valuations = PriceHubble::ValuationRequest.new(...).perform!
# We just want to work on the first valuation
valuation = valuations.first

# Get the deal type dependent value of the property in a generic way.
# (sale price if deal type is sale, and rent gross if deal type is rent)
valuation.value
# => 1283400

# Get the upper and lower value range of the property in a generic
# way. The deal type logic is equal to the
# +PriceHubble::Valuation#value+ method.
valuation.value_range
# => 1180800..1386100

# Query the valuation confidence in an elegant way
valuation.confidence.good?
# => true

# The +PriceHubble::Valuation+ entity is a self contained
# representation of the request and response. This means it includes
# the property, deal type, valuation date, country code, etc it was
# requested for. This makes it easy to process the data because
# everything related is in one place.
valuation.property.property_type.apartment?
# => true
```

#### Error Handling

The property valuation API is able to perform bulk operations which
may result in non-bang situations, even when you use the bang variant.
This is quite smart as a single property valuation might not break
others on the very same request. Watch for the
`PriceHubble::Valuation#status` hash, when it is not nil, then you got
an error for this valuation.

In case you request just one property valuation, then the API will
respond an error which is mapped when you use the bang variants.

```ruby
begin
  # Fetch the valuations for a single property (sale) for today (defaults).
  # This is the bare minimum variant, as a starting point.
  PriceHubble::ValuationRequest.new(
    property: {
      location: {
        address: {
          post_code: '22769',
          city: 'Hamburg',
          street: 'Stresemannstr.',
          house_number: '29'
        }
      },
      property_type: { code: :apartment },
      building_year: 2999,
      living_area: 200
    }
  ).perform!
rescue PriceHubble::EntityInvalid => e
  # => #<PriceHubble::EntityInvalid: buildingYear: ...>

  # The error message includes the detailed problem.
  e.message
  # => "buildingYear: Must be between 1850 and 2022."
end
```

#### Advanced Request Examples

Here comes a more complex example of a property valuations request
with multiple properties, for several valuations dates.

**Gotcha!** The API does not allow you to mix and match the deal type
per property. Therefore you need to set it once for the whole request.

```ruby
# Build a property with all relevant information for the valuation. This
# example reflects not the full list of supported fields, [see the API
# specification](https://docs.pricehubble.com/#types-property) for the full
# details.
apartment = PriceHubble::Property.new(
  location: {
    address: {
      post_code: '22769',
      city: 'Hamburg',
      street: 'Stresemannstr.',
      house_number: '29'
    }
  },
  property_type: { code: :apartment },
  building_year: 1990,
  living_area: 200,
  balcony_Area: 30,
  floor_number: 5,
  has_lift: true,
  is_furnished: false,
  is_new: false,
  renovation_year: 2014,
  condition: {
    bathrooms: :well_maintained,
    kitchen: :well_maintained,
    flooring: :well_maintained,
    windows: :well_maintained,
    masonry: :well_maintained
  },
  quality: {
    bathrooms: :normal,
    kitchen: :normal,
    flooring: :normal,
    windows: :normal,
    masonry: :normal
  }
)

house = PriceHubble::Property.new(
  location: {
    address: {
      post_code: '22769',
      city: 'Hamburg',
      street: 'Stresemannstr.',
      house_number: '29'
    }
  },
  property_type: { code: :house },
  building_year: 1990,
  land_area: 100,
  living_area: 500,
  number_of_floors_in_building: 5
)

# Fetch the property valuations for multiple properties, on multiple dates
request = PriceHubble::ValuationRequest.new(
  deal_type: :sale,
  properties: [apartment, house],
  # The dates order is reflected on the valuations list
  valuation_dates: [
    1.year.ago,
    Date.current,
    1.year.from_now
  ]
)
valuations = request.perform!

# Print the valuations in a simple ASCII table. This is just a
# demonstration of how to use the valuations for a simple usecase.
require 'terminal-table'
table = Terminal::Table.new do |tab|
  tab << ['Deal Type', 'Property Type', *request.valuation_dates.map(&:year)]
  tab << :separator
  # Group the valuations by the property they represent
  valuations.group_by(&:property).each do |property, valuations|
    tab << [request.deal_type, property.property_type.code,
            *valuations.map { |val| "#{val.value} #{val.currency}" }]
  end
end
# => +-----------+---------------+-------------+-------------+-------------+
# => | Deal Type | Property Type | 2018        | 2019        | 2020        |
# => +-----------+---------------+-------------+-------------+-------------+
# => | sale      | apartment     | 1282100 EUR | 1373100 EUR | 1420100 EUR |
# => | sale      | house         | 1824800 EUR | 1950900 EUR | 2016000 EUR |
# => +-----------+---------------+-------------+-------------+-------------+
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bundle exec rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/hausgold/pricehubble.
