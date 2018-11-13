require './lib/constants'
require './lib/player_grid'
require './lib/ship'
require './lib/shot'

RSpec.describe PlayerGrid do
  describe '#initialize' do
    it 'sets up empty ships' do
      player_grid = described_class.new

      result = player_grid.ships

      expect(result).to be_empty
    end
  end

  describe '#valid?' do
    let(:player_grid) { described_class.new }
    let(:ship) { Ship.new('A1, A2', size: 2) }

    context 'when the grid is valid' do
      it 'returns true' do
        player_grid.add_ship(ship)

        result = player_grid.valid?

        expect(result).to eq true
      end
    end

    context 'when the grid is invalid' do
      let(:existing_ship) { Ship.new('A1, A3', size: 3) }
      before { player_grid.ships = [existing_ship] }

      it 'returns false' do
        player_grid.add_ship(ship)

        result = player_grid.valid?

        expect(result).to eq false
      end
    end
  end

  describe '#add_ship' do
    let(:player_grid) { described_class.new }

    it 'adds the ship to the collection' do
      ship = Ship.new('A1, A2', size: 2)

      player_grid.add_ship(ship)
      result = player_grid.ships

      expect(result).to match_array [ship]
    end

    it 'generates the grid' do
      ship = Ship.new('A1, A2', size: 2)

      player_grid.add_ship(ship)
      result = player_grid.draw

      expected = <<~HEREDOC
            1   2   3   4   5   6   7   8   9  10
          |---------------------------------------|
        A | ~ | ~ |   |   |   |   |   |   |   |   |
          |---------------------------------------|
        B |   |   |   |   |   |   |   |   |   |   |
          |---------------------------------------|
        C |   |   |   |   |   |   |   |   |   |   |
          |---------------------------------------|
        D |   |   |   |   |   |   |   |   |   |   |
          |---------------------------------------|
        E |   |   |   |   |   |   |   |   |   |   |
          |---------------------------------------|
        F |   |   |   |   |   |   |   |   |   |   |
          |---------------------------------------|
        G |   |   |   |   |   |   |   |   |   |   |
          |---------------------------------------|
        H |   |   |   |   |   |   |   |   |   |   |
          |---------------------------------------|
        I |   |   |   |   |   |   |   |   |   |   |
          |---------------------------------------|
        J |   |   |   |   |   |   |   |   |   |   |
          |---------------------------------------|
      HEREDOC

      expect(result).to eq expected
    end

    it 'raises an error if not given a ship' do
      ship = { cool: 'object' }

      expect { player_grid.add_ship(ship) }.to raise_error(ArgumentError, 'ship must be type of Ship')
    end

    context 'when ships exist on the grid' do
      let(:existing_ship) { Ship.new('A1, A3', size: 3) }

      before { player_grid.ships = [existing_ship] }

      context 'and the ship does not collide with an existing ship' do
        it 'adds the ship to the collection' do
          ship = Ship.new('A4, A5', size: 2)

          player_grid.add_ship(ship)
          result = player_grid.ships

          expect(result).to match_array [existing_ship, ship]
        end
      end

      context 'and the ship collides with an existing ship' do
        context 'and the ship start point exists at the same start point' do
          let(:ship) { Ship.new('A1, B1', size: 2) }

          it 'adds an error' do
            player_grid.add_ship(ship)

            result = player_grid.errors

            expect(result).to include 'ship collides with existing ships'
          end
        end

        context 'and the ship start point exists at the same end point' do
          let(:ship) { Ship.new('A3, A4', size: 2) }

          it 'adds an error' do
            player_grid.add_ship(ship)

            result = player_grid.errors

            expect(result).to include 'ship collides with existing ships'
          end
        end

        context 'and the ship start point exists between a start and end point' do
          let(:ship) { Ship.new('A2, A2', size: 1) }

          it 'raises an error' do
            player_grid.add_ship(ship)

            result = player_grid.errors

            expect(result).to include 'ship collides with existing ships'
          end
        end
      end
    end
  end

  describe '#receive_shot' do
    let(:player_grid) { described_class.new }
    let(:shot) { Shot.new('A1') }

    context 'when no ship exists at the co-ords of the shot' do
      let(:ship) { Ship.new('A2, A3', size: 2) }

      it 'returns miss' do
        result = player_grid.receive_shot(shot)

        expect(result).to eq Constants::MISS
      end

      it 'does not add damage to a ship' do
        player_grid.receive_shot(shot)

        expect(ship.hits).to be_empty
      end
    end

    context 'when a ship exists at the co-ords of the shot' do
      let(:ship) { Ship.new('A1, B1', size: 2) }
      before { player_grid.ships = [ship] }

      it 'returns hit' do
        result = player_grid.receive_shot(shot)

        expect(result).to eq Constants::HIT
      end

      it 'adds damage to the ship' do
        player_grid.receive_shot(shot)

        expect(ship.hits).to eq [shot.position]
      end
    end
  end
end
