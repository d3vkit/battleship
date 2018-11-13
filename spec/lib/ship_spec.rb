require_relative '../../lib/ship'

RSpec.describe Ship do
  describe '#initialize' do
    it 'has empty errors' do
      ship = Ship.new('A1, A2', size: 2)

      result = ship.errors

      expect(result).to be_empty
    end

    context 'when given a size and co-ords that match' do
      let(:ship) { Ship.new('A1, A2', size: 2) }

      it 'sets the size' do
        result = ship.size

        expect(result).to eq 2
      end
    end
  end

  describe '#type_symbol' do
    it 'returns ~' do
      ship = Ship.new('A1, A2', size: 2)

      result = ship.type_symbol

      expect(result).to eq '~'
    end
  end

  describe '#damaged_symbol' do
    it 'returns red ~' do
      ship = Ship.new('A1, A2', size: 2)

      result = ship.damaged_symbol

      expect(result).to eq "\e[31m~\e[0m"
    end
  end

  describe '#type_symbol_at' do
    let(:ship) { Ship.new('A1, A2', size: 2) }
    let(:type_symbol) { 'X' }
    let(:damaged_symbol) { 'D' }

    before do
      allow(ship).to receive(:type_symbol) { type_symbol }
      allow(ship).to receive(:damaged_symbol) { damaged_symbol }
    end


    context 'when the ship has no hits' do
      it 'returns type symbol' do
        result = ship.type_symbol_at(x: 0, y: 0)

        expect(result).to eq type_symbol
      end
    end

    context 'when the ship has hits at different co-ords' do
      let(:current_hits) { [{ x: 1, y: 0 }] }

      before { ship.hits = current_hits }

      it 'returns type symbol' do
        result = ship.type_symbol_at(x: 0, y: 0)

        expect(result).to eq type_symbol
      end
    end

    context 'when the ship has a hit at the co-ord' do
      let(:current_hits) { [{ x: 0, y: 0 }] }

      before { ship.hits = current_hits }

      it 'returns damaged symbol' do
        result = ship.type_symbol_at(x: 0, y: 0)

        expect(result).to eq damaged_symbol
      end
    end
  end

  describe '#valid?' do
    context 'when position is invalid' do
      it 'adds the errors from position' do
        start_pos = 'A1'
        end_pos = 'B2'
        position = Position.new(start_pos, end_pos)
        ship = Ship.new("#{start_pos}, #{end_pos}", size: 2)
        expected_errors = %w[Some Errors]
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
          ship = Ship.new('A1, A2', size: 3)

          ship.valid?
          result = ship.errors

          expect(result).to include 'Size must be same as co-ords'
        end
      end

      context 'when orientation is vertical' do
        it 'adds an error' do
          ship = Ship.new('A1, B1', size: 3)

          ship.valid?
          result = ship.errors

          expect(result).to include 'Size must be same as co-ords'
        end
      end
    end

    context 'when given a size less than co-ords' do
      context 'when orientation is horizontal' do
        it 'adds an error' do
          ship = Ship.new('A1, A2', size: 1)

          ship.valid?
          result = ship.errors

          expect(result).to include 'Size must be same as co-ords'
        end
      end

      context 'when orientation is vertical' do
        it 'adds an error' do
          ship = Ship.new('A1, B1', size: 1)

          ship.valid?
          result = ship.errors

          expect(result).to include 'Size must be same as co-ords'
        end
      end
    end
  end
end
