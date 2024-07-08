# frozen_string_literal: true

module PriceHubble
  module EntityConcern
    # An ActiveRecord-like attribute management feature, with the exception
    # that the attributes are not generated through a schema file, but are
    # defined inline the entity class.
    #
    module Attributes
      extend ActiveSupport::Concern

      included do
        # Include all custom typed attribute helpers
        include Attributes::DateArray
        include Attributes::Enum
        include Attributes::Range
        include Attributes::StringInquirer

        # Collect all registed attribute names as symbols
        class_attribute :attribute_names

        # Export all attributes as data hash, as requested by the ActiveModel
        # API.
        #
        # @param sanitize [Boolean] whenever to sanitize the data for transport
        # @return [Hash{String => Mixed}] the attribute data
        #
        # rubocop:disable Metrics/MethodLength because of the
        #   key/value sanitization handling
        def attributes(sanitize: false)
          attribute_names.each_with_object({}) do |key, memo|
            reader = key

            if sanitize
              sanitizer = :"sanitize_attr_#{key}"
              reader = methods.include?(sanitizer) ? sanitizer : key

              key_sanitizer = :"sanitize_attr_key_#{key}"
              key = send(key_sanitizer) if methods.include?(key_sanitizer)
            end

            result = resolve_attributes(send(reader))
            memo[key.to_s] = result
          end
        end

        # rubocop:enable Metrics/MethodLength
        # A wrapper for the +ActiveModel#assign_attributes+ method with support
        # for unmapped attributes. These attributes are put into the
        # +_unmapped+ struct and all the known attributes are assigned like
        # normal. This allows the client to be forward compatible with changing
        # APIs.
        #
        # @param struct [Hash{Mixed => Mixed}, RecursiveOpenStruct] the data
        #   to assign
        # @return [Mixed] the input data which was assigned
        def assign_attributes(struct = {})
          # Build a RecursiveOpenStruct and a simple hash from the given data
          struct, hash = sanitize_data(struct)
          # Initialize associations and map them accordingly
          struct, hash = initialize_associations(struct, hash)
          # Initialize attributes and map unknown ones and pass back the known
          known = initialize_attributes(struct, hash)
          # Mass assign the known attributes via ActiveModel
          super(known)
        end

        private

        # Resolve the attributes for the given object while respecting
        # sanitization and deep arrays.
        #
        # @param obj [Mixed] the object to resolve its attributes
        # @param sanitize [Boolean] whenever to sanitize the data for transport
        # @return [Mixed] the attribute(s) data
        #
        # rubocop:disable Metrics/MethodLength because thats the pure minimum
        def resolve_attributes(obj, sanitize: false)
          if obj.respond_to? :attributes
            obj = if obj.method(:attributes).arity == 1
                    obj.attributes(sanitize: sanitize)
                  else
                    obj.attributes
                  end
          end

          if obj.is_a? Array
            obj = obj.map do |elem|
              resolve_attributes(elem, sanitize: sanitize)
            end
          end

          obj
        end
        # rubocop:enable Metrics/MethodLength

        # Explicitly convert the given struct to an +RecursiveOpenStruct+ and a
        # deep symbolized key copy for further usage.
        #
        # @param data [Hash{Mixed => Mixed}, RecursiveOpenStruct] the initial
        #   data
        # @return [Array<RecursiveOpenStruct, Hash{Symbol => Mixed}>] the
        #   left over data
        def sanitize_data(data = {})
          # Convert the given arguments to a recursive open struct,
          # when not already done
          data = ::RecursiveOpenStruct.new(data, recurse_over_arrays: true) \
            unless data.is_a? ::RecursiveOpenStruct
          # Symbolize all keys in deep (including hashes in arrays), while
          # converting back to an ordinary hash
          [data, data.to_h]
        end

        # Process the given data by separating the known from the unknown
        # attributes. The unknown attributes are collected on the +_unmapped+
        # variable for later access. This allows the entities to be
        # forward-compatible on the application HTTP responses in case of
        # additions.
        #
        # @param struct [RecursiveOpenStruct] all the data as struct
        # @param hash [Hash{Symbol => Mixed}] all the data as hash
        # @return [Hash{Symbol => Mixed}] the known attributes
        def initialize_attributes(struct, hash)
          # Substract known keys, to move them to the +_unmapped+ variable
          attribute_names.each { |key| struct.delete_field(key) }
          # Merge the previous unmapped struct and the given data
          self._unmapped =
            ::RecursiveOpenStruct.new(_unmapped.to_h.merge(struct.to_h),
                                      recurse_over_arrays: true)
          # Allow mass assignment of known attributes
          hash.slice(*attribute_names)
        end
      end

      class_methods do
        # Initialize the attributes structures on an inherited class.
        #
        # @param child_class [Class] the child class which inherits us
        def inherited_setup_attributes(child_class)
          child_class.attribute_names = []
        end

        # Register tracked attributes of the entity. This adds the attributes
        # to the +Class.attribute_names+ collection, generates getters and
        # setters as well sets up the dirty-tracking of these attributes.
        #
        # @param args [Array<Symbol>] the attributes to register
        def tracked_attr(*args)
          # Register the attribute names, for easy access
          self.attribute_names += args
          # Define getters/setters
          attr_reader(*args)

          args.each do |arg|
            class_eval <<-RUBY, __FILE__, __LINE__ + 1
              def #{arg}=(value)
                #{arg}_will_change!
                @#{arg} = value
              end
            RUBY
          end
          # Register the attributes for ActiveModel
          define_attribute_methods(*args)
        end

        # (Re-)Register attributes with strict type casts. This adds additional
        # reader methods as well as a writer with casted type.
        #
        # @param name [Symbol, String] the name of the attribute
        # @param type [Symbol] the type of the attribute
        # @param args [Hash{Symbol => Mixed}] additional options for the type
        def typed_attr(name, type, **args)
          send("typed_attr_#{type}", name, **args)
        end
      end
    end
  end
end
