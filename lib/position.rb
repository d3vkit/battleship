require 'ostruct'
require_relative 'modules/error_tracking'
require 'pry'

class Position
  include ErrorTracking
  attr_reader :start_pos, :end_pos

  ORIENTATIONS = { horizontal: 'h', vertical: 'v' }.freeze
  POS_ARR = ('A'..'Z').to_a.freeze

  def initialize(start_pos, end_pos)
    @start_pos, @end_pos = cleanup_position(start_pos, end_pos)
  end

  def valid?
    validate_coords

    errors.empty?
  end

  def co_ords
    horizontal? ? horizontal_coords : vertical_coords
  end

  def matches_size?(size)
    convert_to_size == size
  end

  private

  def cleanup_position(start_pos, end_pos)
    orig_start = convert_pos(start_pos)
    orig_end = convert_pos(end_pos)

    return reverse_point(orig_start, orig_end, :x) if reverse_vertex?(orig_start, orig_end, :x)
    return reverse_point(orig_start, orig_end, :y) if reverse_vertex?(orig_start, orig_end, :y)

    [orig_start, orig_end]
  end

  def reverse_vertex?(start_pos, end_pos, vertex)
    start_pos[vertex] > end_pos[vertex]
  end

  def reverse_point(start_pos, end_pos, vertex)
    new_start = start_pos.dup
    new_end = end_pos.dup

    new_start[vertex] = end_pos[vertex]
    new_end[vertex] = start_pos[vertex]

    [new_start, new_end]
  end

  def horizontal?
    orientation == ORIENTATIONS[:horizontal]
  end

  def vertical?
    orientation == ORIENTATIONS[:vertical]
  end

  def orientation
    return ORIENTATIONS[:vertical] if end_pos[:y] > start_pos[:y]

    ORIENTATIONS[:horizontal] if end_pos[:x] >= start_pos[:x]
  end

  def convert_pos(pos)
    x_pos = convert_x_pos(pos[1, pos.length])
    y_pos = convert_y_pos(pos[0])

    { x: x_pos, y: y_pos }
  end

  def convert_x_pos(x_pos)
    if x_pos !~ /\A\d+\z/
      errors << 'Unknown X Co-ord'

      return -1
    end

    x_pos.to_i - 1
  end

  def convert_y_pos(y_pos)
    POS_ARR.index(y_pos.upcase) || -1
  end

  def validate_coords
    errors << 'Unknown X Co-ord' if bad_x_coord?
    errors << 'Unknown Y Co-ord' if bad_y_coord?
    errors << 'Can not be diagonal co-ords' if diagonal_coords?
    # errors << 'Can not have reverse co-ords' if start_pos[:x] > end_pos[:x] || start_pos[:y] > end_pos[:y]
  end

  def bad_x_coord?
    start_pos[:x] == -1 || end_pos[:x] == -1
  end

  def bad_y_coord?
    start_pos[:y] == -1 || end_pos[:y] == -1
  end

  def diagonal_coords?
    start_pos[:x] != end_pos[:x] && start_pos[:y] != end_pos[:y]
  end

  def convert_to_size
    horizontal? ? convert_position_to_size(:x) : convert_position_to_size(:y)
  end

  def convert_position_to_size(axis)
    (end_pos[axis.to_sym] - start_pos[axis.to_sym]) + 1
  end

  def horizontal_coords
    (start_pos[:x]..end_pos[:x]).map do |x|
      { x: x, y: start_pos[:y] }
    end
  end

  def vertical_coords
    (start_pos[:y]..end_pos[:y]).map do |y|
      { x: start_pos[:x], y: y }
    end
  end
end
