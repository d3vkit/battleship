require './lib/ship'

class Battleship < Ship
  SIZE = 4

  def initialize(position = ',')
    super(position, size: SIZE)
  end

  def name
    'Battleship'
  end

  def type_symbol
    'B'
  end
end
