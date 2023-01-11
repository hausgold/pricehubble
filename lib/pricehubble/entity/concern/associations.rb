# frozen_string_literal: true

module PriceHubble
  module EntityConcern
    # Allow simple association mappings like ActiveRecord supports (eg.
    # +has_one+, +has_many+).
    module Associations
      extend ActiveSupport::Concern

      included do
        # Collect all the registed association configurations
        class_attribute :associations

        private

        # Map the registered associations to the actual instance.
        #
        # @param struct [RecursiveOpenStruct] all the data as struct
        # @param hash [Hash{Symbol => Mixed}] all the data as hash
        # @return [Array<RecursiveOpenStruct, Hash{Symbol => Mixed}>] the
        #   left over data
        def initialize_associations(struct, hash)
          # Walk through the configured associations and set them up
          associations.each_with_object([struct, hash]) do |cur, memo|
            opts = cur.last
            send("map_#{opts[:type]}_association", cur.first, opts, *memo)
          end
        end

        # Map an simple has_one association to the resulting entity attribute.
        # The source key is stripped off according to the association
        # definition.
        #
        # @param attribute [Symbol] the name of the destination attribute
        # @param opts [Hash{Symbol => Mixed}] the association definition
        # @param struct [RecursiveOpenStruct] all the data as struct
        # @param hash [Hash{Symbol => Mixed}] all the data as hash
        # @return [Array<RecursiveOpenStruct, Hash{Symbol => Mixed}>] the
        #   left over data
        #
        # rubocop:disable Metrics/AbcSize because of the complex logic
        # rubocop:disable Metrics/MethodLength because of the complex logic
        def map_has_one_association(attribute, opts, struct, hash)
          # Early exit when the source key is missing on the given data
          key = opts[:from]

          # Initialize an object on the association, even without data
          if opts[:initialize] && send(attribute).nil? && !(hash.key? key)
            hash[key] = {}
          end

          return [struct, hash] unless hash.key? key

          # Instantiate a new entity from the association
          val = hash[key]
          val = opts[:class_name].new(val) unless val.is_a? opts[:class_name]
          send("#{attribute}=", val)

          # Strip off the source key, because we mapped it
          struct.delete_field(key)
          hash = hash.delete(key)
          # Pass back the new data
          [struct, hash]
        end
        # rubocop:enable Metrics/AbcSize
        # rubocop:enable Metrics/MethodLength

        # Map an simple has_many association to the resulting entity attribute.
        # The source key is stripped off according to the association
        # definition. Each element from the source attribute is instantiated
        # separate and is added to the destination collection.
        #
        # @param attribute [Symbol] the name of the destination attribute
        # @param opts [Hash{Symbol => Mixed}] the association definition
        # @param struct [RecursiveOpenStruct] all the data as struct
        # @param hash [Hash{Symbol => Mixed}] all the data as hash
        # @return [Array<RecursiveOpenStruct, Hash{Symbol => Mixed}>] the
        #   left over data
        #
        # rubocop:disable Metrics/AbcSize because of the complex logic
        # rubocop:disable Metrics/CyclomaticComplexity because of the
        #   complex logic
        # rubocop:disable Metrics/PerceivedComplexity because of the
        #   complex logic
        # rubocop:disable Metrics/MethodLength because of the complex logic
        def map_has_many_association(attribute, opts, struct, hash)
          # Early exit when the source key is missing on the given data
          key = opts[:from]

          # When a singular appender was configured, we allow to use it as
          # attribute source if the regular source is not available
          key = opts[:fallback_from] if opts[:fallback_from] && !hash.key?(key)

          # Initialize an empty array on the association
          if opts[:initialize] && send(attribute).nil? && !(hash.key? key)
            hash[key] = []
          end

          return [struct, hash] unless hash.key? key

          # Instantiate a new entity from each association element
          hash[key] = [hash[key]] unless hash[key].is_a? Array
          collection = hash[key].map do |elem|
            next elem if elem.is_a? opts[:class_name]

            opts[:class_name].new(elem)
          end
          send("#{attribute}=", collection)

          # Strip off the source key, because we mapped it
          struct.delete_field(key)
          hash = hash.delete(key)

          # Pass back the new data
          [struct, hash]
        end
        # rubocop:enable Metrics/AbcSize
        # rubocop:enable Metrics/CyclomaticComplexity
        # rubocop:enable Metrics/PerceivedComplexity
        # rubocop:enable Metrics/MethodLength
      end

      # rubocop:disable Naming/PredicateName because we follow
      #   known naming conventions
      class_methods do
        # Initialize the associations structures on an inherited class.
        #
        # @param child_class [Class] the child class which inherits us
        def inherited_setup_associations(child_class)
          child_class.associations = {}
        end

        # Define a simple +has_one+ association.
        #
        # Options
        # * +:class_name+ - the entity class to use, otherwise it is guessed
        # * +:from+ - take the data from this attribute
        # * +:persist+ - whenever to send the association
        #                attributes (default: false)
        # * +:initialize+ - whenever to initialize an empty object
        #
        # @param entity [String, Symbol] the attribute/entity name
        # @param args [Hash{Symbol => Mixed}] additional options
        def has_one(entity, **args)
          # Sanitize options
          entity = entity.to_sym
          opts = { class_name: nil, from: entity, persist: false } \
                 .merge(args).merge(type: :has_one)
          # Resolve the given entity to a class name, when no explicit class
          # name was given via options
          if opts[:class_name].nil?
            opts[:class_name] = \
              entity.to_s.camelcase.prepend('PriceHubble::').constantize
          end
          # Register the association
          associations[entity] = opts
          # Generate getters and setters
          attr_accessor entity

          # Add the entity to the tracked attributes if it should be persisted
          tracked_attr entity if opts[:persist]
        end

        # Define a simple +has_many+ association.
        #
        # Options
        # * +:class_name+ - the entity class to use, otherwise it is guessed
        # * +:from+ - take the data from this attribute
        # * +:fallback_from+ - otherwise take the data from the fallback
        # * +:persist+ - whenever to send the association
        #                attributes (default: false)
        # * +:initialize+ - whenever to initialize an empty array
        #
        # @param entity [String, Symbol] the attribute/entity name
        # @param args [Hash{Symbol => Mixed}] additional options
        def has_many(entity, **args)
          # Sanitize options
          entity = entity.to_sym
          opts = { class_name: nil, from: entity, persist: false } \
                 .merge(args).merge(type: :has_many)
          # Resolve the given entity to a class name, when no explicit class
          # name was given via options
          if opts[:class_name].nil?
            opts[:class_name] = entity.to_s.singularize.camelcase
                                      .prepend('PriceHubble::').constantize
          end
          # Register the association
          associations[entity] = opts
          # Generate getters and setters
          attr_accessor entity

          # Add the entity to the tracked attributes if it should be persisted
          tracked_attr entity if opts[:persist]
        end
      end
      # rubocop:enable Naming/PredicateName
    end
  end
end
