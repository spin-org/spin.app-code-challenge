# frozen_string_literal: true

describe Scooter, type: :model do
  let!(:point) { 'POINT(-55 55)' }
  let!(:moncton) { create(:scooter) } # moncton
  let!(:halifax) { create(:scooter, lonlat: 'POINT(-63.57239 44.64533)') } # halifax NS
  let!(:sackville) { create(:scooter, lonlat: 'POINT(-64.38455 45.91875)') } # sackville_nb
  let!(:hows) { create(:scooter, lonlat: 'POINT(-64.8116827 46.0806427)') } # hows_cres moncton
  let!(:hedgewood) { create(:scooter, lonlat: 'POINT(-64.8059714 46.0823891)') } # hedgewood_dr moncton

  it 'should find 3 scooters within 2 miles of -64.8044808,46.0993307' do
    disallowed_scooters = [halifax.uid, sackville.uid]
    scooters = Scooter.within(-64.8044808, 46.0993307, 2).pluck(:uid)
    expect(scooters.count).to eq(3)
    expect(disallowed_scooters.include?(scooters.sample)).to eq(false)
  end

  it 'should find active scooters' do
    precreate_total = Scooter.all.count
    under_maintenance = create(:scooter, under_maintenance: true, lonlat: point)
    charge_percent = create(:scooter, charge_percent: 0.2999, lonlat: point)
    active_uids = Scooter.active.pluck(:uid)
    expect(active_uids.count).to eq(precreate_total)
    expect(active_uids.include?(under_maintenance.uid) &&
            active_uids.include?(charge_percent.uid)).to eq(false)
  end

  it 'should_create_scooter_state_change' do
    scooter = create(:scooter, lonlat: point)
    scooter.update(charge_percent: 0.65)
    puts scooter.scooter_state_changes.inspect
    expect(scooter.scooter_state_changes.count).to eq(1)
    scooter.update(lonlat: 'POINT(-55.4 55.1)')
    expect(scooter.scooter_state_changes.count).to eq(2)
    scooter.update(under_maintenance: true)
    expect(scooter.scooter_state_changes.count).to eq(3)
  end
end
