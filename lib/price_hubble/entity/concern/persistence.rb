# frozen_string_literal: true

module PriceHubble
  module EntityConcern
    # Map some of the ActiveRecord::Persistence API methods for an entity
    # instance for good compatibility. See: http://bit.ly/2W1rjfF and
    # http://bit.ly/2ARRFYB
    module Persistence
      extend ActiveSupport::Concern

      included do
        # A simple method to query for the state of the entity instance.
        # Returns +false+ whenever the entity or the changes of it were not yet
        # persisted on the remote application. This is helpful for creating new
        # entities from scratch or checking for persisted updates.
        #
        # @return [Boolean] whenever persisted or not
        def persisted?
          return (new_record? ? false : !changed?) \
            if respond_to? :id

          false
        end

        # A simple method to query for the state of the entity instance.
        # Returns +false+ whenever the entity is not yet created on the remote
        # application. This is helpful for creating new entities from scratch.
        #
        # @return [Boolean] whenever persisted or not
        def new_record?
          return id.nil? if respond_to? :id

          true
        end

        # Mark the entity instance as destroyed.
        #
        # @return [Hausgold::BaseEntity] the instance itself for method chaining
        def mark_as_destroyed
          @destroyed = true
          self
        end

        # Returns true if this object has been destroyed, otherwise returns
        # false.
        #
        # @return [Boolean] whenever the entity was destroyed or not
        def destroyed?
          @destroyed == true
        end
      end
    end
  end
end
