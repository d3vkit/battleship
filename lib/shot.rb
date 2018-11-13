require_relative 'coordinate'

class Shot
  attr_reader :position

  def initialize(position)
    @position = Coordinate.new(position).to_hash
  end
end
