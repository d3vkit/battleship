require_relative '../../lib/ship'

RSpec.describe Ship do
  describe '#initialize' do
    it 'has empty errors' do
      ship = Ship.new('A1', 'A2', size: 2)

      result = ship.errors

      expect(result).to be_empty
    end

    context 'when given a size and co-ords that match' do
      let(:ship) { Ship.new('A1', 'A2', size: 2) }

      it 'sets the size' do
        result = ship.size

        expect(result).to eq 2
      end
    end
  end

  describe '#type_symbol' do
    it 'returns ~' do
      ship = Ship.new('A1', 'A2', size: 2)

      result = ship.type_symbol

      expect(result).to eq '~'
    end
  end

  describe '#valid?' do
    context 'when position is invalid' do
      it 'adds the errors from position' do
        start_pos = 'A1'
        end_pos = 'B2'
        position = Position.new(start_pos, end_pos)
        ship = Ship.new(start_pos, end_pos, size: 2)
        expected_errors = ['Some', 'Errors']
        allow(Position).to receive(:new).with(start_pos, end_pos) { position }
        allow(position).to receive(:errors) { expected_errors }

        ship.valid?
        result = ship.errors

        expect(result).to match_array expected_errors
      end
    end

    context 'when given a size greater than co-ords' do
      context 'when orientation is horizontal' do
        it 'adds an error' do
          ship = Ship.new('A1', 'A2', size: 3)
          
          ship.valid?
          result = ship.errors

          expect(result).to include 'Size must be same as co-ords'
        end
      end

      context 'when orientation is vertical' do
        it 'adds an error' do
          ship = Ship.new('A1', 'B1', size: 3)

          ship.valid?
          result = ship.errors
          
          expect(result).to include 'Size must be same as co-ords'
        end
      end
    end

    context 'when given a size less than co-ords' do
      context 'when orientation is horizontal' do
        it 'adds an error' do
          ship = Ship.new('A1', 'A2', size: 1)

          ship.valid?
          result = ship.errors
          
          expect(result).to include 'Size must be same as co-ords'
        end
      end

      context 'when orientation is vertical' do
        it 'adds an error' do
          ship = Ship.new('A1', 'B1', size: 1)

          ship.valid?
          result = ship.errors
          
          expect(result).to include 'Size must be same as co-ords'
        end
      end
    end
  end
end
