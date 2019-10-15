# frozen_string_literal: true

module PriceHubble
  module EntityConcern
    module Attributes
      # A separated range typed attribute helper.
      module Range
        extend ActiveSupport::Concern

        class_methods do
          # Register a range attribute.
          #
          # @param name [Symbol, String] the name of the attribute
          # @param _args [Hash{Symbol => Mixed}] additional options
          def typed_attr_range(name, **_args)
            class_eval <<-RUBY, __FILE__, __LINE__ + 1
              def #{name}
                # We cannot handle nil values
                return unless @#{name}

                # Otherwise we assume the hash contains a +lower+ and +upper+
                # key from which we assemble the range
                hash = @#{name}
                hash[:lower]..hash[:upper]
              end
            RUBY
          end
        end
      end
    end
  end
end
