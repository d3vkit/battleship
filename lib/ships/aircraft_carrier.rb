require_relative '../ship'

class AircraftCarrier < Ship
  SIZE = 5

  def initialize(position = ',')
    super(position, size: SIZE)
  end

  def name
    'Aircraft Carrier'
  end

  def type_symbol
    'A'
  end
end
