# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/SpecFilePathFormat because these classes are specially
#   mapped to be included in the gem root namespace
RSpec.describe PriceHubble::Address do
  let(:instance) { build(:address) }

  describe 'attributes' do
    let(:expected) do
      {
        'city' => 'Hamburg',
        'house_number' => '29',
        'post_code' => '22769',
        'street' => 'Stresemannstr.'
      }
    end

    it 'serializes the correct data' do
      expect(instance.attributes).to eql(expected)
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
