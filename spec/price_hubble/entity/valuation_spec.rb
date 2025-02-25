# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/SpecFilePathFormat -- because these classes are
#   specially mapped to be included in the gem root namespace
RSpec.describe PriceHubble::Valuation do
  let(:instance) { build(:valuation) }

  describe 'attributes' do
    let(:expected) do
      {
        'currency' => 'EUR',
        'sale_price' => 1_313_700,
        'sale_price_range' => 1_208_600..1_418_800,
        'rent_gross' => nil,
        'rent_gross_range' => nil,
        'rent_net' => nil,
        'rent_net_range' => nil,
        'confidence' => 'good',
        'scores' => {
          'quality' => nil,
          'condition' => nil,
          'location' => nil
        },
        'status' => nil,
        'deal_type' => 'sale',
        'valuation_date' => Date.current,
        'country_code' => 'DE',
        'property' => build(:property).attributes
      }
    end

    it 'serializes the correct data' do
      expect(instance.attributes).to eql(expected)
    end

    describe 'custom typed attributes' do
      describe 'ranges' do
        it 'returns the correct range' do
          expect(instance.sale_price_range).to eql(1_208_600..1_418_800)
        end

        it 'returns nil when underlying data is missing' do
          expect(instance.rent_gross_range).to be_nil
        end
      end
    end
  end

  describe '#value' do
    let(:params) { {} }
    let(:value) { 10 }
    let(:instance) { build(:valuation, deal_type: deal_type, **params) }

    context 'with sale deal type' do
      let(:deal_type) { :sale }

      context 'with data present' do
        let(:params) { { sale_price: value } }

        it 'returns the correct value' do
          expect(instance.value).to be(10)
        end
      end

      context 'without data' do
        let(:params) { { sale_price: nil } }

        it 'returns nil' do
          expect(instance.value).to be_nil
        end
      end
    end

    context 'with rent deal type' do
      let(:deal_type) { :rent }

      context 'with data present' do
        let(:params) { { rent_gross: value } }

        it 'returns the correct value' do
          expect(instance.value).to be(10)
        end
      end

      context 'without data' do
        let(:params) { { rent_gross_range: nil } }

        it 'returns nil' do
          expect(instance.value).to be_nil
        end
      end
    end
  end

  describe '#value_range' do
    let(:params) { {} }
    let(:range) { { lower: 5, upper: 10 } }
    let(:instance) { build(:valuation, deal_type: deal_type, **params) }

    context 'with sale deal type' do
      let(:deal_type) { :sale }

      context 'with data present' do
        let(:params) { { sale_price_range: range } }

        it 'returns the correct range' do
          expect(instance.value_range).to eql(5..10)
        end
      end

      context 'without data' do
        let(:params) { { sale_price_range: nil } }

        it 'returns nil' do
          expect(instance.value_range).to be_nil
        end
      end
    end

    context 'with rent deal type' do
      let(:deal_type) { :rent }

      context 'with data present' do
        let(:params) { { rent_gross_range: range } }

        it 'returns the correct range' do
          expect(instance.value_range).to eql(5..10)
        end
      end

      context 'without data' do
        let(:params) { { rent_gross_range: nil } }

        it 'returns nil' do
          expect(instance.value_range).to be_nil
        end
      end
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
