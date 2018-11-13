require './lib/ship'

class Cruiser < Ship
  SIZE = 3

  def initialize(start_pos = '', end_pos = '')
    super(start_pos, end_pos, size: SIZE)
  end

  def name
    'Cruiser'
  end

  def type_symbol
    'C'
  end
end
