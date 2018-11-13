require './lib/ship'

class Submarine < Ship
  SIZE = 1

  def initialize(start_pos = '', end_pos = '')
    super(start_pos, end_pos, size: SIZE)
  end

  def name
    'Submarine'
  end

  def type_symbol
    'S'
  end
end
