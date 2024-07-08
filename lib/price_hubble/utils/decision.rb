# frozen_string_literal: true

module PriceHubble
  module Utils
    # Provides an easy to use decision DSL which works like a flow control.
    # (eg. if conditions, or a switch statement) It should DRY out the
    # processing logic on clients, while make decisions about the status of the
    # response. The decision helper evaluates the answers to: Should we raise
    # an error or return a default value? Was the response any good?
    #
    # Example:
    #
    #   decision(bang: true) do |result|
    #     result.fail { nil }
    #     result.bang { Hausgold::AuthenticationError.new(nil, res, res.body) }
    #     result.good { Hausgold::Jwt.new(res.body).clear_changes }
    #     successful?(res)
    #   end
    module Decision
      extend ActiveSupport::Concern

      included do
        # Allow users to build decision paths and run them according to the
        # result. This is a kind of flow control like an if condition, or a
        # switch statement. It contains three decision result paths, the happy
        # case (good), an error case for regular issues (fail) and a error case
        # for fatal issues (bang). You can configure the decision which error
        # behaiviour you prefer by setting the +bang+ argument to true or
        # false.
        #
        # @param bang [Boolean] whenever to bang or not
        # @yield Runtime to collect the settings and the result
        # @return [Mixed] the result of the decision (good|fail|bang) block
        def decision(bang: false, &block)
          runtime = Runtime.new(on_error: bang ? :bang : :fail)
          runtime.evaluate(&block)
        end
      end

      # An inline runtime class to abstract the decision making.
      class Runtime
        # Generate getters for the runtime settings
        attr_reader :on_error, :bang_proc, :fail_proc, :good_proc

        # Create a new decision runtime object which collect all the result
        # paths, and then evaluates the decision.
        #
        # @param on_error [Symbol] the error way
        def initialize(on_error: :fail)
          @on_error = on_error
          @bang_proc = -> { StandardError.new }
          @fail_proc = @good_proc = -> {}
        end

        # Register a new error (bang) way. Requires a block.
        #
        # @param block [Proc] the block to run in case of errors
        def bang(&block)
          @bang_proc = block
        end

        # Register a new error (fail) way. Requires a block.
        #
        # @param block [Proc] the block to run in case of errors
        def fail(&block)
          @fail_proc = block
        end

        # Register a new success (good) way. Requires a block.
        #
        # @param block [Proc] the block to run in case of success
        def good(&block)
          @good_proc = block
        end

        # Returns the prefered error method block, based on the +on_error+
        # setting.
        #
        # @return [Proc] the error block we should use
        def error_proc
          return fail_proc if on_error == :fail

          -> { raise bang_proc.call }
        end

        # Evaluate the decision.
        #
        # @yield Runtime to collect the settings and the result
        # @return [Mixed] the result of the decision (good|fail|bang) block
        def evaluate
          result = yield(self)
          result ? good_proc.call : error_proc.call
        end
      end
    end
  end
end
