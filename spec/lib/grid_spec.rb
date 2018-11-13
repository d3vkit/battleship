require './lib/grid'
require './lib/ship'

=begin
  Default Grid:
 
=end

RSpec.describe Grid do
  describe '#initialize' do
    it 'sets up empty ships' do
      grid = Grid.new

      result = grid.ships

      expect(result).to be_empty
    end
  end

  describe '#valid?' do
    let(:grid) { Grid.new }
    let(:ship) { Ship.new('A1', 'A2', size: 2) }

    context 'when the grid is valid' do
      it 'returns true' do
        grid.add_ship(ship)

        result = grid.valid?

        expect(result).to eq true
      end
    end

    context 'when the grid is invalid' do
      let(:existing_ship) { Ship.new('A1', 'A3', size: 3) }
      before { grid.ships = [existing_ship] }

      it 'returns false' do
        grid.add_ship(ship)

        result = grid.valid?

        expect(result).to eq false
      end
    end
  end

  describe '#draw' do
    let(:grid) { Grid.new }

    it 'returns the stylized grid' do
      results = grid.draw

      expected = <<~HEREDOC
            1   2   3   4   5   6   7   8   9  10 
          |---------------------------------------|
        A |   |   |   |   |   |   |   |   |   |   |
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

      expect(results).to eq expected
    end

    context 'with ships on the grid' do
      let(:ship1) { Ship.new('A1', 'A2', size: 2) }
      let(:ship2) { Ship.new('B1', 'B3', size: 3) }

      before { grid.ships = [ship1, ship2] }

      it 'returns the stylized grid' do
        expected = <<~HEREDOC
              1   2   3   4   5   6   7   8   9  10 
            |---------------------------------------|
          A | ~ | ~ |   |   |   |   |   |   |   |   |
            |---------------------------------------|
          B | ~ | ~ | ~ |   |   |   |   |   |   |   |
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

        results = grid.draw

        expect(results).to eq expected
      end
    end
  end

  describe '#add_ship' do
    let(:grid) { Grid.new }

    it 'adds the ship to the collection' do
      ship = Ship.new('A1', 'A2', size: 2)

      grid.add_ship(ship)
      result = grid.ships

      expect(result).to match_array [ship]
    end

    it 'generates the grid' do
      ship = Ship.new('A1', 'A2', size: 2)

      grid.add_ship(ship)
      result = grid.draw

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

      expect { grid.add_ship(ship) }.to raise_error(ArgumentError, 'ship must be type of Ship')
    end

    context 'when ships exist on the grid' do
      let(:existing_ship) { Ship.new('A1', 'A3', size: 3) }

      before { grid.ships = [existing_ship] }

      context 'and the ship does not collide with an existing ship' do
        it 'adds the ship to the collection' do
          ship = Ship.new('A4', 'A5', size: 2)

          grid.add_ship(ship)
          result = grid.ships

          expect(result).to match_array [existing_ship, ship]
        end
      end

      context 'and the ship collides with an existing ship' do
        context 'and the ship start point exists at the same start point' do
          let(:ship) { Ship.new('A1', 'B1', size: 2) }

          it 'adds an error' do
            grid.add_ship(ship)

            result = grid.errors

            expect(result).to include 'ship collides with existing ships'
          end
        end

        context 'and the ship start point exists at the same end point' do
          let(:ship) { Ship.new('A3', 'A4', size: 2) }

          it 'adds an error' do
            grid.add_ship(ship)

            result = grid.errors

            expect(result).to include 'ship collides with existing ships'
          end
        end

        context 'and the ship start point exists between a start and end point' do
          let(:ship) { Ship.new('A2', 'A2', size: 1) }

          it 'raises an error' do
            grid.add_ship(ship)

            result = grid.errors
            
            expect(result).to include 'ship collides with existing ships'
          end
        end
      end
    end
  end
end
