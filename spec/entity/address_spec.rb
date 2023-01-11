# frozen_string_literal: true

require 'spec_helper'

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
      expect(instance.attributes).to be_eql(expected)
    end
  end
end
