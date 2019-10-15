# frozen_string_literal: true

# All our Ruby core extensions for the +Hash+ class.
class Hash
  # Perform the regular +Hash#compact+ method on the object but takes care of
  # deeply nested hashs.
  #
  # @return [Hash]
  def deep_compact
    deep_compact_in_object(self)
  end

  # Perform a deep key transformation on the hash,
  # so all keys are in camelcase.
  #
  # @return [Hash]
  def deep_camelize_keys
    deep_transform_keys { |key| key.to_s.camelize(:lower) }
  end

  # Perform a deep key transformation on the hash,
  # so all keys are in snakecase/underscored.
  #
  # @return [Hash]
  def deep_underscore_keys
    deep_transform_keys { |key| key.to_s.underscore }
  end

  private

  # A supporting helper to allow deep hash compaction.
  #
  # @param object [Mixed] the object to compact
  # @return [Mixed] the compacted object
  #
  # rubocop:disable Metrics/MethodLength because of the extra empty
  #   hash compaction logic
  def deep_compact_in_object(object)
    case object
    when Hash
      object = object.compact.each_with_object({}) do |(key, value), result|
        result[key] = deep_compact_in_object(value)
      end
      object.empty? ? nil : object.compact
    when Array
      object.map { |item| deep_compact_in_object(item) }
    else
      object
    end
  end
  # rubocop:enable Metrics/MethodLength
end
