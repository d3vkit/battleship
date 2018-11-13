require_relative 'game_manager'
require_relative 'position'
require_relative 'modules/error_tracking'

class Ship
  include ErrorTracking
  attr_accessor :start_pos, :end_pos
  attr_reader :size

  def initialize(start_pos, end_pos, size:)
    @start_pos = start_pos
    @end_pos = end_pos
    @size = size
  end

  def name
    'Ship'
  end

  def type_symbol
    '~'
  end

  def valid?
    validate_size_and_position
    position.valid?
    self.errors += position.errors

    self.errors.empty?
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

  def setup(grid_image)
    GameManager.instance.waiting = true

    while GameManager.instance.waiting?
      GameManager.write("Enter position for #{name} (#{size} spaces)\n#{grid_image}\n")

      @start_pos = GameManager.collect_input('Start Position: ')
      @end_pos = GameManager.collect_input('End Position: ')

      GameManager.instance.waiting = valid?

      next unless errors.any?

      GameManager.clear_screen
      GameManager.write("#{error_message}\n")

      clear_errors
    end
  end

  private

  def validate_size_and_position
    return if position.matches_size?(size)

    self.errors << 'Size must be same as co-ords'
  end
end
