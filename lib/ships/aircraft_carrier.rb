require_relative '../ship'

class AircraftCarrier < Ship
  SIZE = 5

  def initialize(start_pos = '', end_pos = '')
    super(start_pos, end_pos, size: SIZE)
  end

  def name
    'Aircraft Carrier'
  end

  def type_symbol
    'A'
  end
end
