# frozen_string_literal: true

module PriceHubble
  module EntityConcern
    module Attributes
      # A separated date array typed attribute helper.
      module DateArray
        extend ActiveSupport::Concern

        class_methods do
          # Register a date array attribute (only sanitization).
          #
          # @param name [Symbol, String] the name of the attribute
          # @param _args [Hash{Symbol => Mixed}] additional options
          def typed_attr_date_array(name, **_args)
            class_eval <<-RUBY, __FILE__, __LINE__ + 1
              def sanitize_attr_#{name}
                return if @#{name}.nil?
                @#{name}.map do |date|
                  date.strftime('%Y-%m-%d')
                end
              end
            RUBY
          end
        end
      end
    end
  end
end
