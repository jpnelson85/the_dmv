require 'spec_helper'
require './lib/facility'
require './lib/vehicle'
require './lib/facility'

RSpec.describe Facility do
  before(:each) do
    @facility = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
  end
  describe '#initialize' do
    it 'can initialize' do
      expect(@facility).to be_an_instance_of(Facility)
      expect(@facility.name).to eq('Albany DMV Office')
      expect(@facility.address).to eq('2242 Santiam Hwy SE Albany OR 97321')
      expect(@facility.phone).to eq('541-967-2014')
      expect(@facility.services).to eq([])
    end
  end

  describe '#add service' do
    it 'can add available services' do
      expect(@facility.services).to eq([])
      @facility.add_service('New Drivers License')
      @facility.add_service('Renew Drivers License')
      @facility.add_service('Vehicle Registration')
      expect(@facility.services).to eq(['New Drivers License', 'Renew Drivers License', 'Vehicle Registration'])
    end
  end

    it 'registration_date is nil by default' do
      cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
      expect(cruz.registration_date).to eq(nil)
    end

    it 'registed vehicles is empty array' do
      facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
      expect(facility_1.registered_vehicles).to eq([])
    end

    it 'collected fees starts with zero' do
      facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
      expect(facility_1.collected_fees).to eq(0)
    end

    it 'register vehicles' do
      facility_2 = Facility.new({name: 'Another Facility', address: '456 Oak Ave', phone: '555-555-5555'})
      bolt = Vehicle.new({vin: '987654321xyz', year: 2020, make: 'Chevrolet', model: 'Bolt', engine: :electric})
      expect(facility_2.registered_vehicles).to eq([])
      expect(facility_2.services).to eq([])
      expect(facility_2.registered_vehicles).to eq([])
      expect(facility_2.registered_vehicles).to eq([])
      expect(facility_2.collected_fees).to eq(0)
    end

    it 'written, license, and renewed all false for reg_1' do
      registrant_1 = Registrant.new('Bruce', 18, true )
      expect(registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
    end
  
    it 'registrant_1 has a permit?' do
      facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
      registrant_1 = Registrant.new('Bruce', 18, true )
      expect(registrant_1.permit?).to eq(true)
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
      facility_1.administer_written_test(registrant_1)
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
      facility_1.administer_written_test(registrant_1)
      expect(facility_1.administer_road_test(registrant_1)).to eq(true)
      expect(registrant_1.license_data).to eq({:written=>true, :license=>true, :renewed=>false})
  
      expect(registrant_2.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
      registrant_2.earn_permit
      facility_1.administer_written_test(registrant_2)
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
      registrant_1.earn_permit
      registrant_2.earn_permit
      registrant_3.earn_permit

      facility_1.administer_written_test(registrant_1)
      facility_1.administer_road_test(registrant_1)
      expect(facility_1.renew_drivers_license(registrant_1)).to eq(false)
      expect(facility_1.add_service('Renew License')).to eq(["Written Test", "Road Test", "Renew License"])
      expect(facility_1.renew_drivers_license(registrant_1)).to eq(true)
      expect(registrant_1.license_data).to eq({:written=>true, :license=>true, :renewed=>true})
  
      expect(registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
      facility_1.renew_drivers_license(registrant_3)
      expect(registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false})

      facility_1.administer_written_test(registrant_2)
      facility_1.administer_road_test(registrant_2)
      expect(facility_1.renew_drivers_license(registrant_2)).to eq(true)
      expect(registrant_2.license_data).to eq({:written=>true, :license=>true, :renewed=>true})
    end
end
