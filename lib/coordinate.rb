class Coordinate
  POS_ARR = ('A'..'Z').to_a.freeze

  def initialize(position)
    @x_pos = convert_x_pos(position[1, position.length])
    @y_pos = convert_y_pos(position[0])
  end

  def to_hash
    { x: @x_pos, y: @y_pos }
  end

  private

  def convert_x_pos(x_pos)
    return -1 if x_pos !~ /\A\d+\z/

    x_pos.to_i - 1
  end

  def convert_y_pos(y_pos)
    POS_ARR.index(y_pos.upcase) || -1
  end
end
