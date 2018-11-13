require_relative '../../../lib/modules/error_tracking'

class MyKlass
  include ErrorTracking

  def display_errors
    errors
  end
end

RSpec.describe ErrorTracking do
  let(:klass) { MyKlass.new }

  describe '#errors' do
    context 'when there are no errors' do
      it 'returns an empty array' do
        result = klass.errors

        expect(result).to be_empty
      end
    end

    context 'when there are errors' do
      let(:error) { 'Some Error' }
      before { klass.errors = [error] }

      it 'returns the errors' do
        result = klass.errors

        expect(result).to match_array [error]
      end

      it 'returns from instance method' do
        result = klass.display_errors

        expect(result).to match_array [error]
      end
    end
  end

  describe '#clear_errors' do
    context 'when there are no errors' do
      it 'sets errors to an empty array' do
        klass.clear_errors

        result = klass.errors

        expect(result).to be_empty
      end
    end

    context 'when there are errors' do
      let(:error) { 'Some Error' }
      before { klass.errors = [error] }

      it 'sets errors to an empty array' do
        klass.clear_errors

        result = klass.errors

        expect(result).to be_empty
      end
    end
  end
end