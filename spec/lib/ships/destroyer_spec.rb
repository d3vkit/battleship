require './lib/ships/destroyer'

RSpec.describe Destroyer do
  describe '#initialize' do
    let(:start_pos) { 'A1' }
    let(:end_pos) { 'A2' }
    let(:position_str) { "#{start_pos}, #{end_pos}" }

    it 'sets the given position' do
      position = Position.new(start_pos, end_pos)
      allow(Position).to receive(:new).with(start_pos, end_pos) { position }

      ship = Destroyer.new(position_str)
      result = ship.position

      expect(result).to eq position
    end

    it 'has a size of 2' do
      ship = Destroyer.new(position_str)

      result = ship.size

      expect(result).to eq 2
    end
  end
end
