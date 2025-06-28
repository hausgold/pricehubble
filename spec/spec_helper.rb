# frozen_string_literal: true

require 'simplecov'
SimpleCov.command_name 'specs'

require 'bundler/setup'
require 'pricehubble'
require 'timecop'

# Load all support helpers and shared examples
Dir[File.join(__dir__, 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Enable the focus inclusion filter and run all when no filter is set
  # See: http://bit.ly/2TVkcIh
  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Clear and recreate the tmp directory before each test case
  config.before do
    FileUtils.rm_rf(tmp_path)
    FileUtils.mkdir_p(tmp_path)
  end

  # Clear the test configuration before we begin
  config.before do
    reset_test_configuration!
  end

  # Add VCR to all tests
  unless ENV.fetch('VCR', 'true') == 'false'
    config.around do |example|
      vcr_tag = example.metadata[:vcr]
      next VCR.turned_off(&example) if vcr_tag == false

      options = vcr_tag.is_a?(Hash) ? vcr_tag : {}
      name = options.fetch(:name, nil)
      options.except!(:name)
      path_data = [example.metadata[:description]]
      parent = example.example_group

      while parent != RSpec::Core::ExampleGroup
        path_data << parent.metadata[:description]
        parent = parent.superclass
      end

      name ||= path_data.map do |str|
        str.underscore.delete('.').gsub(%r{[^\w/]+}, '_').gsub(%r{/$}, '')
      end.reverse.join('/')

      VCR.use_cassette(name, options, &example)
    end
  end
end
