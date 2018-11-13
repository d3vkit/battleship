require './lib/ship'

class Battleship < Ship
  SIZE = 4

  def initialize(start_pos = '', end_pos = '')
    super(start_pos, end_pos, size: SIZE)
  end

  def name
    'Battleship'
  end

  def type_symbol
    'B'
  end
end
