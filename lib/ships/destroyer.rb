require './lib/ship'

class Destroyer < Ship
  SIZE = 2

  def initialize(position = ',')
    super(position, size: SIZE)
  end

  def name
    'Destroyer'
  end

  def type_symbol
    'D'
  end
end
