### 0.4.0

* Added initial dossier handling (create, delete, sharing link) (#3)

### 0.3.0

* Dropped support for Rails <5.2 (#2)
* Dropped support for Ruby <2.5 (#2)
* Updated the faraday gem spec to `~> 1.0` (#2)

### 0.2.0

* Added a configuration for request logging which is enabled by default now
* Implemented a generic instrumentation facility
* Improved the instrumentation and request logging facility (logs are colored
  now to make local development easier and error handling was added to be more
  robust on response issues)

### 0.1.0

* Implemented a transparent authentication handling
* Implemented all shared data types (`PriceHubble::Location`,
  `PriceHubble::Coordinates`, `PriceHubble::Address`, `PriceHubble::Property`,
  `PriceHubble::PropertyType`)
* Implemented the international property valuation
  (`PriceHubble::ValuationRequest`)
* Added a set of examples and wrote the usage documentation
