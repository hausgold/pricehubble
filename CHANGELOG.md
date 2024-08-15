### next

* TODO: Replace this bullet point with an actual description of a change.

### 1.2.3

* Just a retag of 1.2.1

### 1.2.2

* Just a retag of 1.2.1

### 1.2.1

* Added API docs building to continuous integration (#9)

### 1.2.0

* Moved the development dependencies from the gemspec to the Gemfile (#7)
* Dropped support for Ruby <2.7 (#8)

### 1.1.0

* Added support for Gem release automation

### 1.0.0

* Bundler >= 2.3 is from now on required as minimal version (#5)
* Dropped support for Ruby < 2.5 (#5)
* Dropped support for Rails < 5.2 (#5)
* Updated all development/runtime gems to their latest
  Ruby 2.5 compatible version (#5)
* [Breaking Change] The `sanitize` argument of the
  `PriceHubble::BaseEntity#attributes(sanitize = false)` method has changed to
  a keyword argument `PriceHubble::BaseEntity#attributes(sanitize: false)` (#5)

### 0.4.2

* Migrated to Github Actions
* Migrated to our own coverage reporting
* Added the code statistics to the test process

### 0.4.1

* Corrected the GNU Make release target

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
