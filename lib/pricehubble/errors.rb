# frozen_string_literal: true

module PriceHubble
  # Generic entity exception class.
  class EntityError < StandardError
  end

  # Generic request/response exception class.
  class RequestError < StandardError
    attr_reader :response

    # Create a new instance of the error.
    #
    # @param message [String] the error message
    # @param response [Faraday::Response] the response
    def initialize(message = nil, response = nil)
      @response = response
      message ||= response.body.message if response.body.respond_to? :message

      super(message)
    end
  end

  # Raised when the authentication request failed.
  class AuthenticationError < RequestError; end

  # Raised when an entity was not found while searching/getting.
  class EntityNotFound < EntityError
    attr_reader :entity, :criteria

    # Create a new instance of the error.
    #
    # @param message [String] the error message
    # @param entity [PriceHubble::BaseEntity] the entity which was not found
    # @param criteria [Hash{Symbol => Mixed}] the search/find criteria
    def initialize(message = nil, entity = nil, criteria = {})
      @entity = entity
      @criteria = criteria
      message ||= "Couldn't find #{entity} with #{criteria.inspect}"

      super(message)
    end
  end

  # Raised when the record is invalid, due to a response.
  class EntityInvalid < EntityError
    attr_reader :entity

    # Create a new instance of the error.
    #
    # @param message [String] the error message
    # @param entity [PriceHubble::BaseEntity] the entity which was invalid
    def initialize(message = nil, entity = nil)
      @entity = entity
      message ||= "Invalid #{entity}"

      super(message)
    end
  end
end
