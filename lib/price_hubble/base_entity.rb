# frozen_string_literal: true

module PriceHubble
  # The base entity, with a lot of known ActiveRecord/ActiveModel features.
  class BaseEntity
    include ActiveModel::Model
    include ActiveModel::Dirty

    include PriceHubble::Utils::Bangers

    # Additional singleton class functionalities
    class << self
      include PriceHubble::Utils::Bangers
    end

    include Concern::Callbacks
    include Concern::Attributes
    include Concern::Associations
    include Concern::Client
    include Concern::Persistence

    # We collect all unknown attributes instead of raising while creating a new
    # instance. The unknown attributes are wrapped inside a
    # +RecursiveOpenStruct+ to ease the accessibility. This also allows us to
    # handle responses in a forward-compatible way.
    attr_accessor :_unmapped

    # Create a new instance of an entity with a lot of known
    # ActiveRecord/ActiveModel features.
    #
    # @param struct [Hash{Mixed => Mixed}, RecursiveOpenStruct] the initial data
    # @return [PriceHubble::BaseEntity] a compatible instance
    # @yield [PriceHubble::BaseEntity] the entity itself in the end
    def initialize(struct = {})
      # Set the initial unmapped struct
      self._unmapped = RecursiveOpenStruct.new
      # Build a RecursiveOpenStruct and a simple hash from the given data
      struct, hash = sanitize_data(struct)
      # Initialize associations and map them accordingly
      struct, hash = initialize_associations(struct, hash)
      # Initialize attributes and map unknown ones and pass back the known
      known = initialize_attributes(struct, hash)
      # Mass assign the known attributes via ActiveModel
      super(known)
      # Follow the ActiveRecord API
      yield self if block_given?
      # Run the initializer callbacks
      _run_initialize_callbacks
    end

    class << self
      # Initialize the class we were inherited to. We trigger all our methods
      # which start with +inherited_setup_+ to allow per-concern/feature based
      # initialization after BaseEntity inheritance.
      #
      # @param child_class [Class] the child class which inherits us
      def inherited(child_class)
        super
        match = ->(sym) { sym.to_s.start_with? 'inherited_setup_' }
        trigger = ->(sym) { send(sym, child_class) }
        methods.select(&match).each(&trigger)
      end
    end
  end
end
