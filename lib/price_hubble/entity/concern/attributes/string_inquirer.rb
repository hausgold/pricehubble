# frozen_string_literal: true

module PriceHubble
  module EntityConcern
    module Attributes
      # A separated string inquirer typed attribute helper.
      module StringInquirer
        extend ActiveSupport::Concern

        class_methods do
          # Register a casted string inquirer attribute.
          #
          # @param name [Symbol, String] the name of the attribute
          # @param _args [Hash{Symbol => Mixed}] additional options
          def typed_attr_string_inquirer(name, **_args)
            class_eval <<-RUBY, __FILE__, __LINE__ + 1
              def #{name}=(value)
                #{name}_will_change!
                @#{name} = ActiveSupport::StringInquirer.new(value.to_s)
              end
            RUBY
          end
        end
      end
    end
  end
end
