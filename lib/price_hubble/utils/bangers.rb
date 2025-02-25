# frozen_string_literal: true

module PriceHubble
  module Utils
    # Generate bang variants of methods which use the +Decision+ flow control.
    module Bangers
      extend ActiveSupport::Concern

      class_methods do
        # Generate bang variants for the given methods.
        # Be sure to use the +bangers+ class method AFTER all method
        # definitions, otherwise it will raise errors about missing methods.
        #
        # @param methods [Array<Symbol>] the source method names
        # @raise [NoMethodError] when a source method is not defined
        # @raise [ArgumentError] when a source method does not accept arguments
        #
        # rubocop:disable Metrics/MethodLength -- because the method template
        #   is better inlined
        def bangers(*methods)
          methods.each do |meth|
            raise NoMethodError, "#{self}##{meth} does not exit" \
              unless instance_methods(false).include? meth

            if instance_method(meth).arity.zero?
              raise ArgumentError,
                    "#{self}##{meth} does not accept arguments"
            end

            class_eval <<-RUBY, __FILE__, __LINE__ + 1
              def #{meth}!(*args, **kwargs, &block)
                #{meth}(*args, **kwargs, bang: true, &block)
              end
            RUBY
          end
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
