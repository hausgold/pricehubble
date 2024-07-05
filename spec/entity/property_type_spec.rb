# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PriceHubble::PropertyType do
  let(:instance) { build(:property_type) }

  describe 'attributes' do
    let(:expected) do
      {
        'code' => :apartment,
        'subcode' => :apartment_normal
      }
    end

    it 'serializes the correct data' do
      expect(instance.attributes).to eql(expected)
    end

    describe 'custom typed attributes' do
      describe 'enums' do
        it 'allows to set a valid value' do
          expect(described_class.new(code: :house).code).to be(:house)
        end

        it 'raises an ArgumentError on invalid values' do
          expect { described_class.new(code: :unknown) }.to \
            raise_error(ArgumentError, /'unknown'/)
        end
      end
    end
  end
end
