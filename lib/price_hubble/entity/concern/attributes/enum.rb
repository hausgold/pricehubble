# frozen_string_literal: true

module PriceHubble
  module Concern
    module Attributes
      # A separated enum typed attribute helper.
      module Enum
        extend ActiveSupport::Concern

        class_methods do
          # Register a fixed enum attribute.
          #
          # @param name [Symbol, String] the name of the attribute
          # @param values [Array<String, Symbol>] the allowed values
          # @param _args [Hash{Symbol => Mixed}] additional options
          #
          # rubocop:disable Metrics/MethodLength because of the inline
          #   meta method definitions
          def typed_attr_enum(name, values:, **_args)
            values = values.map(&:to_sym)
            const_values = "ATTR_#{name.to_s.upcase}"

            class_eval <<-RUBY, __FILE__, __LINE__ + 1
              # Define the constant for all valid values
              #{const_values} = #{values}.freeze

              def #{name}=(value)
                #{name}_will_change!
                value = value.to_sym

                unless #{const_values}.include? value
                  raise ArgumentError, "'\#{value}' is not a valid #{name} " \
                    "(values: \#{#{const_values}})"
                end

                @#{name} = value
              end
            RUBY

            values.each do |value|
              class_eval <<-RUBY, __FILE__, __LINE__ + 1
                def #{value}!
                  self.#{name} = :#{value}
                end

                def #{value}?
                  self.#{name} == :#{value}
                end
              RUBY
            end
          end
          # rubocop:enable Metrics/MethodLength
        end
      end
    end
  end
end
