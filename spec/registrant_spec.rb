require 'spec_helper'

RSpec.describe Registrant do
  it 'creates a registrant with the given name, age, and permit status' do
    registrant_1 = Registrant.new('Bruce', 18, true)
    expect(registrant_1.name).to eq('Bruce')
    expect(registrant_1.age).to eq(18)
    expect(registrant_1.permit?).to be(true)
    expect(registrant_1.license_data).to eq({ written: false, license: false, renewed: false })
  end

  it 'creates a registrant with the given name, age, and permit status' do
    registrant_2 = Registrant.new('Penny', 15)
    expect(registrant_2.name).to eq('Penny')
    expect(registrant_2.age).to eq(15)
    expect(registrant_2.permit?).to be(false)
    expect(registrant_2.license_data).to eq({ written: false, license: false, renewed: false })
  end

  it 'does not give the registrant another permit' do
    registrant_2 = Registrant.new('Penny', 15)
    expect(registrant_2.permit?).to be(false)
    registrant_2.earn_permit
    expect(registrant_2.permit?).to be(true)
  end

  it 'can administer written test and change license data' do
    registrant_1 = Registrant.new('Bruce', 18, true )
    registrant_2 = Registrant.new('Penny', 16 )
    registrant_3 = Registrant.new('Tucker', 15 )
    facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
    facility_2 = Facility.new({name: 'Ashland DMV Office', address: '600 Tolman Creek Rd Ashland OR 97520', phone: '541-776-6092' })
    
    expect(registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
    expect(registrant_1.permit?).to eq(true)
    expect(facility_1.administer_written_test(registrant_1)).to eq(false)
    expect(registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
    facility_1.add_service('Written Test')
    expect(registrant_1.license_data).to eq({:written=>true, :license=>false, :renewed=>false})
    
    expect(registrant_2.age).to eq(16)
    expect(registrant_2.permit?).to eq(false)
    expect(facility_1.administer_written_test(registrant_2)).to eq(false)
    registrant_2.earn_permit
    expect(facility_1.administer_written_test(registrant_2)).to eq(true)
    expect(registrant_2.license_data).to eq({:written=>true, :license=>false, :renewed=>false})

    expect(registrant_3.age).to eq(15)
    expect(registrant_3.permit?).to eq(false)
    expect(facility_1.administer_written_test(registrant_3)).to eq(false)
    expect(registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
  end

  it 'can administer road test' do
    registrant_1 = Registrant.new('Bruce', 18, true )
    registrant_2 = Registrant.new('Penny', 16 )
    registrant_3 = Registrant.new('Tucker', 15 )
    facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
    facility_2 = Facility.new({name: 'Ashland DMV Office', address: '600 Tolman Creek Rd Ashland OR 97520', phone: '541-776-6092' })
    facility_1.add_service('Written Test')

    expect(facility_1.administer_road_test(registrant_3)).to eq(false)
    registrant_3.earn_permit
    expect(facility_1.administer_road_test(registrant_3)).to eq(false)
    expect(registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
    
    expect(facility_1.administer_road_test(registrant_1)).to eq(false)
    expect(facility_1.add_service('Road Test')).to eq(['Written Test', 'Road Test'])
    expect(facility_1.administer_road_test(registrant_1)).to eq(true)
    expect(registrant_1.license_data).to eq({:written=>true, :license=>true, :renewed=>false})

    expect(facility_1.administer_road_test(registrant_2)).to eq(true)
    expect(registrant_2.license_data).to eq({:written=>true, :license=>true, :renewed=>false})
  end

  it 'can renew a license' do
    registrant_1 = Registrant.new('Bruce', 18, true )
    registrant_2 = Registrant.new('Penny', 16 )
    registrant_3 = Registrant.new('Tucker', 15 )
    facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
    facility_2 = Facility.new({name: 'Ashland DMV Office', address: '600 Tolman Creek Rd Ashland OR 97520', phone: '541-776-6092' })
    facility_1.add_service('Written Test')
    facility_1.add_service('Road Test')

    expect(facility_1.renew_drivers_license(registrant_1)).to eq(false)
    expect(facility_1.add_service('Renew License')).to eq(["Written Test", "Road Test", "Renew License"])
    expect(facility_1.renew_drivers_license(registrant_1)).to eq(true)
    expect(registrant_1.license_data).to eq({:written=>true, :license=>true, :renewed=>true})

    expect(facility_1.renew_drivers_license(registrant_3)).to eq(false)
    expect(registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
    expect(facility_1.renew_drivers_license(registrant_2)).to eq(true)
    expect(registrant_2.license_data).to eq({:written=>true, :license=>true, :renewed=>true})

  end
end



