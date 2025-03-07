# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/SpecFilePathFormat -- because these classes are
#   specially mapped to be included in the gem root namespace
RSpec.describe PriceHubble::Location do
  let(:instance) { build(:location, :full) }

  describe 'attributes' do
    let(:expected) do
      {
        'address' => {
          'city' => 'Hamburg',
          'house_number' => '29',
          'post_code' => '22769',
          'street' => 'Stresemannstr.'
        },
        'coordinates' => {
          'latitude' => 53.5598602,
          'longitude' => 9.9608857
        }
      }
    end

    it 'serializes the correct data' do
      expect(instance.attributes).to eql(expected)
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
