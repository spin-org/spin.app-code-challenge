# frozen_string_literal: true

require 'rails_helper'
require 'api/scooter_controller'

describe Api::ScooterController, type: :controller do
  let(:lat) { 46.0970001 }
  let(:lon) { -64.8000001 }
  let(:charge_percent) { 1.0 }
  let(:uuid) { SecureRandom.uuid }

  it 'updates a scooter' do
    num_scooters = Scooter.all.count
    scooter = create(:scooter)
    put :update, params: { uid: scooter.uid,
                           lon: lon,
                           lat: lat,
                           charge_percent: charge_percent }
    scooter = Scooter.last
    expect(Scooter.all.count).to eq(num_scooters + 1)
    expect(scooter.lonlat.to_s).to eq("POINT (#{lon} #{lat})")
    expect(scooter.charge_percent).to eq(charge_percent)
  end

  context 'with time ' do
    it 'should find an active scooter' do
      time = Time.new(2018, 3, 7, 10, 35, 42, '-04:00')
      allow(Time).to receive(:now).and_return(time)
      create(:scooter)
      res = get :active, params: { lon: lon,
                                   lat: lat,
                                   radius_in_mi: 1,
                                   utc_offset: '-04:00' }
      expect(!JSON.parse(res.body).empty?).to eq(true)
    end

    it 'should not find an active scooter' do
      time = Time.new(2018, 3, 7, 6, 35, 42, '-04:00')
      allow(Time).to receive(:now).and_return(time)
      create(:scooter)
      res = get :active, params: { lon: lon,
                                   lat: lat,
                                   radius_in_mi: 1,
                                   utc_offset: '-04:00' }
      expect(JSON.parse(res.body).empty?).to eq(true)
    end
  end

  it 'should fetch historical data' do
    city = create(:city, name:'Test City')
    scooter = create(:scooter, city_id: city.id)
    res = get :historical_data, params: {city_id: city.id}
    expect(JSON.parse(res.body).empty?).to eq(true)
    put :update, params: { uid: scooter.uid,
                           lon: lon,
                           lat: lat,
                           charge_percent: charge_percent }
    res = get :historical_data, params: {city_id: city.id}
    expect(JSON.parse(res.body).empty?).to eq(false)
  end

  it 'should go offline' do
    scooter = create(:scooter)
    expect(scooter.under_maintenance).to eq(false)
    put :take_scooter_offline_for_maintenance, params: { id:scooter }
    expect(Scooter.last.under_maintenance).to eq(true)
  end
end
