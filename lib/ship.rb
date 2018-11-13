require_relative 'game_manager'
require_relative 'position'
require_relative 'text_manager'
require_relative 'modules/error_tracking'
require 'pry'

class Ship
  include ErrorTracking
  attr_accessor :start_pos, :end_pos, :hits
  attr_reader :size

  def initialize(position_str = ',', size:)
    @start_pos, @end_pos = position_str.split(',').map(&:strip)
    @size = size
    @hits = []
  end

  def setup(grid_image)
    valid = false

    until valid
      GameManager.write("#{grid_image}\nEnter position for #{name} (#{size} spaces)\n\n")
      GameManager.write('Enter position as comma separated string (A1, A2)')

      position_str = GameManager.collect_input('Position: ')
      @start_pos, @end_pos = position_str.split(',').map(&:strip)

      valid = valid?

      next unless errors.any?

      GameManager.clear_screen
      GameManager.write("#{error_message}\n")

      clear_errors
    end
  end

  def name
    'Ship'
  end

  def type_symbol
    '~'
  end

  def type_symbol_at(co_ord)
    hit_at?(co_ord) ? damaged_symbol : type_symbol
  end

  def damaged_symbol
    TextManager.red(type_symbol)
  end

  def valid?
    validate_size_and_position
    position.valid?
    self.errors += position.errors

    errors.empty?
  end

  def position
    Position.new(@start_pos, @end_pos)
  end

  def co_ords
    position.co_ords
  end

  def in_bounds?(x, y)
    co_ords.any? { |co_ord| co_ord[:y] < y || co_ord[:x] < x }
  end

  def covers_ship?(grid)
    co_ords.any? { |co_ord| !grid[co_ord[:y]][co_ord[:x]].nil? }
  end

  def hit_at?(co_ord)
    hits.any? { |hit_coord| hit_coord[:x] == co_ord[:x] && hit_coord[:y] == co_ord[:y] }
  end

  def coord_at?(co_ord)
    co_ords.any? { |ship_coord| ship_coord[:x] == co_ord[:x] && ship_coord[:y] == co_ord[:y] }
  end

  def hit(co_ord)
    @hits << co_ord
  end

  private

  def validate_size_and_position
    return if position.matches_size?(size)

    self.errors << 'Size must be same as co-ords'
  end
end
