require './lib/ship'

class Submarine < Ship
  SIZE = 1

  def initialize(position = ',')
    super(position, size: SIZE)
  end

  def name
    'Submarine'
  end

  def type_symbol
    'S'
  end
end
