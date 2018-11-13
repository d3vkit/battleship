require_relative '../../../lib/ships/aircraft_carrier'

RSpec.describe AircraftCarrier do
  describe '#initialize' do
    it 'has a ship with size 5' do
      aircraft_carrier = AircraftCarrier.new('A1, A2')

      result = aircraft_carrier.size

      expect(result).to eq 5
    end
  end
end
