# frozen_string_literal: true

# A custom Ruby logger matcher. Use it like this:
#
#   expect { action }.to \
#     log_at_level(:info, '[RID] origin -> 200/OK (11.4ms)')
#
# @param level [Symbol, String] the name of the log level (lowercase)
# @param expected [String, Regexp] the expected string/regexp which was logged
# @param logger [Logger] the logger object to use
RSpec::Matchers.define(
  :log_at_level
) do |level, expected, logger: PriceHubble.logger|
  supports_block_expectations

  match do |expectation_block|
    # A buffer to track all logger invocations (eg. +info+)
    @calls = []

    # Track all logger invocations for the given level
    allow(logger).to receive(level) do |*args, &block|
      message = block.call if block
      message ||= args.first if args.any?
      @calls << message if message
    end

    # Run the expectation block
    expectation_block.call

    # When no logger invocations where tracked, the match fails
    next false if @calls.empty?

    # Otherwise search for matching logger invocations, by their resulting log
    # strings, comparing to the given expected string/regex
    @matched_message = @calls.find do |msg|
      case expected
      when Regexp then msg =~ expected
      else
        msg == expected
      end
    end
    !@matched_message.nil?
  end

  failure_message do
    if @calls.empty?
      "expected logger.#{level} to be called, but it was not"
    else
      res = @calls.map { |cur| "  - #{cur.inspect}" }.join("\n")
      "expected a #{level} log matching #{expected.inspect}, got:\n#{res}"
    end
  end
end
