require './lib/position'

RSpec.describe Position do
  describe '#initialize' do
    context 'when given co-ords at start of grid' do
      let(:position) { Position.new('A1', 'A1') }

      it 'converts start pos co-ords to grid position' do
        result = position.start_pos

        expect(result).to eq(x: 0, y: 0)
      end

      it 'converts end pos co-ords to grid position' do
        result = position.end_pos

        expect(result).to eq(x: 0, y: 0)
      end
    end

    context 'when given co-ords at end of grid' do
      let(:position) { Position.new('J10', 'J10') }

      it 'converts start pos co-ords to grid position' do
        result = position.start_pos

        expect(result).to eq(x: 9, y: 9)
      end

      it 'converts end pos co-ords to grid position' do
        result = position.end_pos

        expect(result).to eq(x: 9, y: 9)
      end
    end

    context 'when given co-ords in middle of grid' do
      let(:position) { Position.new('E5', 'E5') }

      it 'converts start pos co-ords to grid position' do
        result = position.start_pos

        expect(result).to eq(x: 4, y: 4)
      end

      it 'converts end pos co-ords to grid position' do
        result = position.end_pos

        expect(result).to eq(x: 4, y: 4)
      end
    end

    context 'when given horizontal co-ords' do
      let(:position) { Position.new('A1', 'A2') }

      it 'converts start pos co-ords to grid position' do
        result = position.start_pos

        expect(result).to eq(x: 0, y: 0)
      end

      it 'converts end pos co-ords to grid position' do
        result = position.end_pos

        expect(result).to eq(x: 1, y: 0)
      end
    end

    context 'when given vertical co-ords' do
      let(:position) { Position.new('A1', 'B1') }

      it 'converts start pos co-ords to grid position' do
        result = position.start_pos

        expect(result).to eq(x: 0, y: 0)
      end

      it 'converts end pos co-ords to grid position' do
        result = position.end_pos

        expect(result).to eq(x: 0, y: 1)
      end
    end

    context 'when given lower case co-ords' do
      let(:position) { Position.new('b1', 'b2') }

      it 'converts start co-ords to grid position' do
        result = position.start_pos

        expect(result).to eq(x: 0, y: 1)
      end

      it 'converts end co-ords to grid position' do
        result = position.end_pos

        expect(result).to eq(x: 1, y: 1)
      end
    end

    context 'when given backwards x co-ords' do
      let(:position) { Position.new('A2', 'A1') }

      it 'reverses the start pos co-ords' do
        result = position.start_pos

        expect(result).to eq(x: 0, y: 0)
      end

      it 'reverses the end pos co-ords' do
        result = position.end_pos

        expect(result).to eq(x: 1, y: 0)
      end
    end

    context 'when given backwards y co-ords' do
      let(:position) { Position.new('B1', 'A1') }

      it 'reverses the start pos co-ords' do
        result = position.start_pos

        expect(result).to eq(x: 0, y: 0)
      end

      it 'reverses the end pos co-ords' do
        result = position.end_pos

        expect(result).to eq(x: 0, y: 1)
      end
    end
  end

  describe '#valid?' do
    context 'when given co-ords outside of grid' do
      context 'when given bad start pos' do
        it 'adds an error for non positive integer' do
          position = Position.new('AA1', 'A1')

          position.valid?
          result = position.errors

          expect(result).to include 'Unknown X Co-ord'
        end
      end

      context 'when given bad end pos' do
        it 'adds an error for non positive integer' do
          position = Position.new('A1', 'AA1')

          position.valid?
          result = position.errors

          expect(result).to include 'Unknown X Co-ord'
        end
      end
    end

    context 'when given co-ords that are diagonal' do
      it 'adds an error' do
        position = Position.new('A1', 'B2')

        position.valid?
        result = position.errors

        expect(result).to include 'Can not be diagonal co-ords'
      end
    end
  end

  describe '#co_ords' do
    context 'when given start and end of one space' do
      it 'returns co-ords for the single space' do
        position = Position.new('A1', 'A1')

        result = position.co_ords
        expected = [{ x: 0, y: 0 }]

        expect(result).to eq expected
      end
    end

    context 'when given start and end of two spaces' do
      context 'when the spaces are horizontal' do
        it 'returns co-ords for the two spaces' do
          position = Position.new('A1', 'A2')

          result = position.co_ords
          expected = [{ x: 0, y: 0 }, { x: 1, y: 0 }]

          expect(result).to eq expected
        end
      end

      context 'when the spaces are vertical' do
        it 'returns co-ords for the two spaces' do
          position = Position.new('A1', 'B1')

          result = position.co_ords
          expected = [{ x: 0, y: 0 }, { x: 0, y: 1 }]

          expect(result).to eq expected
        end
      end
    end
    context 'when given start and end of multiple spaces' do
      context 'when the spaces are horizontal' do
        it 'returns co-ords for all spaces' do
          position = Position.new('A1', 'A5')

          result = position.co_ords
          expected = [
            { x: 0, y: 0 },
            { x: 1, y: 0 },
            { x: 2, y: 0 },
            { x: 3, y: 0 },
            { x: 4, y: 0 },
          ]

          expect(result).to eq expected
        end
      end

      context 'when the spaces are vertical' do
        it 'returns co-ords for all spaces' do
          position = Position.new('A1', 'E1')

          result = position.co_ords
          expected = [
            { x: 0, y: 0 },
            { x: 0, y: 1 },
            { x: 0, y: 2 },
            { x: 0, y: 3 },
            { x: 0, y: 4 },
          ]

          expect(result).to eq expected
        end
      end
    end
  end

  describe '#matches_size?' do
    it 'works' do
      position = Position.new('B1', 'B2')
      size = 2

      result = position.matches_size?(size)

      expect(result).to eq true
    end
  end
end
