require_relative 'game'
require_relative 'game_manager'
require_relative 'modules/error_tracking'
require_relative 'grid_renderer'
require_relative 'ship'
require_relative 'ships/aircraft_carrier'
require_relative 'ships/battleship'
require_relative 'ships/cruiser'
require_relative 'ships/destroyer'
require_relative 'ships/submarine'

class Grid
  include ErrorTracking
  attr_reader :ships

  BOUNDS = { x: 10, y: 10 }.freeze

  def initialize
    @ships = []
    @grid = generate_grid
  end

  def setup
    GameManager.clear_screen
    GameManager.instance.waiting = true

    while GameManager.instance.waiting?
      ship = next_ship_needed

      ship ? setup_ship(ship) : GameManager.instance.waiting = false
    end
  end

  def draw
    GridRenderer.new(@grid).draw
  end

  def ships=(ships)
    new_ships = Array(ships)

    raise ArgumentError, 'must all be Ships' unless new_ships.all? { |ship| ship.is_a?(Ship) }

    @ships = new_ships
    @grid = generate_grid
  end

  def add_ship(ship)
    raise ArgumentError, 'ship must be type of Ship' unless ship.is_a?(Ship)

    errors = check_ship_position(ship)

    if errors
      self.errors << errors

      return
    end

    @ships.push(ship)
    @grid = generate_grid
  end

  private

  def generate_grid
    default_grid = Array.new(BOUNDS[:y]) { Array.new(BOUNDS[:x]) }

    ships.each do |ship|
      ship.co_ords.each do |co_ord|
        default_grid[co_ord[:y]][co_ord[:x]] = " #{ship.type_symbol} "
      end
    end

    default_grid
  end

  def check_ship_position(ship)
    if !ship.in_bounds?(BOUNDS[:x], BOUNDS[:y])
      'Ship out of bounds'
    elsif ship.covers_ship?(@grid)
      'ship collides with existing ships'
    end
  end

  def next_ship_needed
    ship_count.each_key do |ship_klass|
      count = ships.count { |ship| ship.is_a?(ship_klass) }

      return ship_klass.new if count < ship_count[ship_klass]
    end

    nil
  end

  def setup_ship(ship)
    GameManager.instance.waiting = true

    while GameManager.instance.waiting?
      ship.setup(draw)
      add_ship(ship)

      GameManager.instance.waiting = valid?
      GameManager.clear_screen

      next unless errors.any?

      GameManager.write("#{error_message}\n")

      clear_errors
    end
  end

  def ship_count
    @ship_count ||= {
      AircraftCarrier => 1,
      Battleship => 1,
      # Cruiser => 1,
      # Destroyer => 2,
      # Submarine => 2,
    }
  end
end
