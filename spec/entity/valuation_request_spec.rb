# frozen_string_literal: true

RSpec.describe PriceHubble::ValuationRequest do
  let(:instance) { build(:valuation_request) }

  before { Timecop.freeze(2019, 10, 16, 12, 0, 0) }

  after { Timecop.return }

  describe 'attributes' do
    context 'without sanitization' do
      let(:expected) do
        {
          'deal_type' => :sale,
          'valuation_dates' => [Date.current],
          'properties' => [build(:property).attributes],
          'return_scores' => false,
          'country_code' => 'DE'
        }
      end

      it 'serializes the correct data' do
        expect(instance.attributes).to be_eql(expected)
      end
    end

    context 'with sanitization' do
      let(:expected) do
        {
          'deal_type' => :sale,
          'valuation_dates' => ['2019-10-16'],
          'valuation_inputs' => [
            { property: build(:property).attributes(true) }
          ],
          'return_scores' => false,
          'country_code' => 'DE'
        }
      end

      it 'serializes the correct data' do
        expect(instance.attributes(true)).to be_eql(expected)
      end
    end

    describe 'mass assignment' do
      context 'with single property instance' do
        let(:instance) { described_class.new(property: build(:property)) }

        it 'assigns the correct data' do
          expect(instance.properties.first.location.address.street).to \
            be_eql('Stresemannstr.')
        end
      end

      context 'with single property attributes' do
        let(:instance) do
          described_class.new(property: attributes_for(:property))
        end

        it 'assigns the correct data' do
          expect(instance.properties.first.location.address.street).to \
            be_eql('Stresemannstr.')
        end
      end

      context 'with multiple property instances' do
        let(:instance) do
          described_class.new(properties: [build(:property), build(:property)])
        end

        it 'assigns the correct data' do
          expect(instance.properties.count).to be_eql(2)
        end
      end

      context 'with multiple property attribute sets' do
        let(:instance) do
          described_class.new(properties: [attributes_for(:property),
                                           attributes_for(:property)])
        end

        it 'assigns the correct data' do
          expect(instance.properties.count).to be_eql(2)
        end
      end
    end
  end

  describe '#perform!' do
    let(:action) { instance.perform! }

    context 'with valid data', vcr: cassette(:valuation_request) do
      it 'returns an array of PriceHubble::Valuation' do
        expect(action).to all(be_a(PriceHubble::Valuation))
      end
    end

    context 'with invalid data', vcr: cassette(:valuation_request_bad) do
      let(:invalid_property) { build(:property, building_year: 2999) }
      let(:instance) do
        build(:valuation_request, properties: [invalid_property])
      end

      it 'raises a PriceHubble::EntityInvalid error' do
        expect { action }.to \
          raise_error(PriceHubble::EntityInvalid,
                      /buildingYear: Must be between 1850 and 2022/)
      end
    end
  end
end
