# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PriceHubble::Coordinates do
  let(:instance) { build(:coordinates) }

  describe 'attributes' do
    let(:expected) do
      {
        'latitude' => 53.5598602,
        'longitude' => 9.9608857
      }
    end

    it 'serializes the correct data' do
      expect(instance.attributes).to eql(expected)
    end
  end
end
