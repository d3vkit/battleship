require './lib/ship'

class Cruiser < Ship
  SIZE = 3

  def initialize(position = ',')
    super(position, size: SIZE)
  end

  def name
    'Cruiser'
  end

  def type_symbol
    'C'
  end
end
