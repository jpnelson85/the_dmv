require 'spec_helper'

RSpec.describe Vehicle do

  it 'exists and has attributes' do
    facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
    facility_2 = Facility.new({name: 'Ashland DMV Office', address: '600 Tolman Creek Rd Ashland OR 97520', phone: '541-776-6092' })
    cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
    bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev} )
    camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice} )
    facility_1.add_service('Vehicle Registration')  
    expect(cruz).to be_an_instance_of(Vehicle)
    expect(cruz.vin).to eq('123456789abcdefgh')
    expect(cruz.year).to eq(2012)
    expect(cruz.make).to eq('Chevrolet')
    expect(cruz.model).to eq('Cruz')
    expect(cruz.engine).to eq(:ice)
    expect(cruz.plate_type).to eq(nil)
    expect(cruz.registration_date).to eq(nil)
    expect(facility_1.registered_vehicles).to eq([])
    expect(facility_1.collected_fees).to eq(0)
  end

  it 'can register revicles' do
    facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
    facility_2 = Facility.new({name: 'Ashland DMV Office', address: '600 Tolman Creek Rd Ashland OR 97520', phone: '541-776-6092' })
    cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
    bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev} )
    camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice} )
    facility_1.add_service('Vehicle Registration')  
    facility_1.register_vehicle(cruz)
    expect(cruz.registration_date).to be_a(Date.today)
    expect(cruz.plate_type).to eq(:regular)
    expect(facility_1.registed_vehicles).to eq([cruz])
    expect(facility_1.collected_fees).to eq(100)
    facility_1.register_vehicle(camaro)
    expect(camaro.registration_date).to be_a(Date.today)
    expect(camaro.plate_type).to eq(:ev)
    expect(facility_1.registered_vehicles).to eq([cruz, camaro])
    facility_1.register_vehicle(bolt)
    expect(bolt.registration_date).to be_a(Date.today)
    expect(bolt.plate_type).to eq(:ev)
    expect(facility_1.registered_vehicles).to eq([cruz, camaro, bolt])
    expect(facility_1.collected_fees).to eq(325)
  end

  it 'register for facility 2' do
    facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
    facility_2 = Facility.new({name: 'Ashland DMV Office', address: '600 Tolman Creek Rd Ashland OR 97520', phone: '541-776-6092' })
    cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
    bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev} )
    camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice} )
    facility_1.add_service('Vehicle Registration')  
    expect(facility_2.registered_vehicles).to eq([])
    expect(facility_2.services).to eq([])
    expect(facility_2.register_vehicle(bolt)).to eq(nil)
    expect(facility_2.registered_vehicles).to eq([])
    expect(facility_2.collected_fees).to eq(0)
  end

  # it 'can determine if a vehicle is an antique' do
  #   expect(@cruz.antique?).to eq(false)
  #   expect(@bolt.antique?).to eq(false)
  #   expect(@camaro.antique?).to eq(true)
  # end

  # it 'can determine if a vehicle is an ev' do
  #   expect(@cruz.electric_vehicle?).to eq(false)
  #   expect(@bolt.electric_vehicle?).to eq(true)
  #   expect(@camaro.electric_vehicle?).to eq(false)
  # end
end
