# frozen_string_literal: true

FactoryBot.define do
  factory :property, class: PriceHubble::Property do
    location { build(:location) }
    property_type { build(:property_type) }
    building_year { 1990 }
    living_area { 200 }
    balcony_area { 30 }
    floor_number { 1 }
    has_lift { true }
    is_furnished { false }
    is_new { false }
    renovation_year { 2014 }
    condition { build(:property_conditions) }
    quality { build(:property_qualities) }
  end
end

FactoryBot.define do
  factory :property_type, class: PriceHubble::PropertyType do
    code { :apartment }
    subcode { :apartment_normal }
  end
end

FactoryBot.define do
  factory :property_conditions, class: PriceHubble::PropertyConditions do
    bathrooms { :well_maintained }
    kitchen { :well_maintained }
    flooring { :well_maintained }
    windows { :well_maintained }
    masonry { :well_maintained }
  end
end

FactoryBot.define do
  factory :property_qualities, class: PriceHubble::PropertyQualities do
    bathrooms { :normal }
    kitchen { :normal }
    flooring { :normal }
    windows { :normal }
    masonry { :normal }
  end
end
