### next

* Corrected some RuboCop glitches (#17)
* Drop Ruby 2 and end of life Rails (<7.1) (#18)

### 1.6.1 (21 May 2025)

* Corrected some RuboCop glitches ([#15](https://github.com/hausgold/pricehubble/pull/15))
* Upgraded the rubocop dependencies ([#16](https://github.com/hausgold/pricehubble/pull/16))

### 1.6.0 (30 January 2025)

* Added all versions up to Ruby 3.4 to the CI matrix ([#14](https://github.com/hausgold/pricehubble/pull/14))

### 1.5.1 (17 January 2025)

* Added the logger dependency ([#13](https://github.com/hausgold/pricehubble/pull/13))

### 1.5.0 (12 January 2025)

* Switched to Zeitwerk as autoloader ([#12](https://github.com/hausgold/pricehubble/pull/12))

### 1.4.0 (3 January 2025)

* Raised minimum supported Ruby/Rails version to 2.7/6.1 ([#11](https://github.com/hausgold/pricehubble/pull/11))

### 1.3.0 (4 October 2024)

* Upgraded the `recursive-open-struct` gem to `~> 2.0` ([#10](https://github.com/hausgold/pricehubble/pull/10))

### 1.2.5 (15 August 2024)

* Just a retag of 1.2.1

### 1.2.4 (15 August 2024)

* Just a retag of 1.2.1

### 1.2.3 (15 August 2024)

* Just a retag of 1.2.1

### 1.2.2 (9 August 2024)

* Just a retag of 1.2.1

### 1.2.1 (9 August 2024)

* Added API docs building to continuous integration ([#9](https://github.com/hausgold/pricehubble/pull/9))

### 1.2.0 (8 July 2024)

* Moved the development dependencies from the gemspec to the Gemfile ([#7](https://github.com/hausgold/pricehubble/pull/7))
* Dropped support for Ruby <2.7 ([#8](https://github.com/hausgold/pricehubble/pull/8))

### 1.1.0 (24 February 2023)

* Added support for Gem release automation

### 1.0.0 (18 January 2023)

* Bundler >= 2.3 is from now on required as minimal version ([#5](https://github.com/hausgold/pricehubble/pull/5))
* Dropped support for Ruby < 2.5 ([#5](https://github.com/hausgold/pricehubble/pull/5))
* Dropped support for Rails < 5.2 ([#5](https://github.com/hausgold/pricehubble/pull/5))
* Updated all development/runtime gems to their latest
  Ruby 2.5 compatible version ([#5](https://github.com/hausgold/pricehubble/pull/5))
* [Breaking Change] The `sanitize` argument of the
  `PriceHubble::BaseEntity#attributes(sanitize = false)` method has changed to
  a keyword argument `PriceHubble::BaseEntity#attributes(sanitize: false)` ([#5](https://github.com/hausgold/pricehubble/pull/5))

### 0.4.2 (15 October 2021)

* Migrated to Github Actions
* Migrated to our own coverage reporting
* Added the code statistics to the test process

### 0.4.1 (12 May 2021)

* Corrected the GNU Make release target

### 0.4.0 (11 December 2020)

* Added initial dossier handling (create, delete, sharing link) ([#3](https://github.com/hausgold/pricehubble/pull/3))

### 0.3.0 (9 September 2020)

* Dropped support for Rails <5.2 ([#2](https://github.com/hausgold/pricehubble/pull/2))
* Dropped support for Ruby <2.5 ([#2](https://github.com/hausgold/pricehubble/pull/2))
* Updated the faraday gem spec to `~> 1.0` ([#2](https://github.com/hausgold/pricehubble/pull/2))

### 0.2.0 (22 October 2019)

* Added a configuration for request logging which is enabled by default now
* Implemented a generic instrumentation facility
* Improved the instrumentation and request logging facility (logs are colored
  now to make local development easier and error handling was added to be more
  robust on response issues)

### 0.1.0 (15 October 2019)

* Implemented a transparent authentication handling
* Implemented all shared data types (`PriceHubble::Location`,
  `PriceHubble::Coordinates`, `PriceHubble::Address`, `PriceHubble::Property`,
  `PriceHubble::PropertyType`)
* Implemented the international property valuation
  (`PriceHubble::ValuationRequest`)
* Added a set of examples and wrote the usage documentation
