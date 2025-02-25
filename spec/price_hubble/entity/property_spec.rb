# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/SpecFilePathFormat -- because these classes are
#   specially mapped to be included in the gem root namespace
RSpec.describe PriceHubble::Property do
  let(:instance) { build(:property) }

  describe 'attributes' do
    let(:expected) do
      {
        'location' => {
          'address' => build(:address).attributes,
          'coordinates' => {
            'latitude' => nil,
            'longitude' => nil
          }
        },
        'property_type' => build(:property_type).attributes,
        'building_year' => 1990,
        'living_area' => 200,
        'land_area' => nil,
        'garden_area' => nil,
        'volume' => nil,
        'number_of_rooms' => nil,
        'number_of_bathrooms' => nil,
        'balcony_area' => 30,
        'number_of_indoor_parking_spaces' => nil,
        'number_of_outdoor_parking_spaces' => nil,
        'floor_number' => 1,
        'has_lift' => true,
        'energy_label' => nil,
        'has_sauna' => nil,
        'has_pool' => nil,
        'number_of_floors_in_building' => nil,
        'is_furnished' => false,
        'is_new' => false,
        'renovation_year' => 2014,
        'condition' => build(:property_conditions).attributes,
        'quality' => build(:property_qualities).attributes
      }
    end

    it 'serializes the correct data' do
      expect(instance.attributes).to eql(expected)
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
