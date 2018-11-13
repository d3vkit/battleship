require './lib/ship'

class Destroyer < Ship
  SIZE = 2

  def initialize(start_pos = '', end_pos = '')
    super(start_pos, end_pos, size: SIZE)
  end

  def name
    'Destroyer'
  end

  def type_symbol
    'D'
  end
end
