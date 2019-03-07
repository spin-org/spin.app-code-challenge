# frozen_string_literal: true

FactoryBot.define do
  factory :scooter_state_change do
    scooter_id { 1 }
    attr_changed { %w[under_maintenance lonlat charge_percent city_id].sample }
  end

  factory :city do
    name { Faker::Address.city }
  end

  factory :scooter do
    uid { SecureRandom.uuid }
    lonlat { 'POINT(-64.800 46.097)' } # Moncton NB
    charge_percent { 1.0 }
    city_id { create(:city).id }
    under_maintenance { false }
  end
end
