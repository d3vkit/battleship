require_relative 'game'
require_relative 'game_manager'
require_relative 'modules/error_tracking'
require_relative 'constants'
require_relative 'grid'
require_relative 'grid_renderer'
require_relative 'ship'
require_relative 'ships/aircraft_carrier'
require_relative 'ships/battleship'
require_relative 'ships/cruiser'
require_relative 'ships/destroyer'
require_relative 'ships/submarine'

class PlayerGrid < Grid
  include ErrorTracking
  attr_reader :ships, :grid

  def initialize
    @ships = []
    @grid = generate_grid
  end

  def setup
    GameManager.clear_screen

    ships_needed.each { |ship| setup_ship(ship) }
  end

  def draw(fog_of_war: false)
    renderer = GridRenderer.new(@grid)

    fog_of_war ? renderer.draw_with_fog_of_war : renderer.draw
  end

  def ships=(ships)
    new_ships = Array(ships)

    raise ArgumentError, 'must all be Ships' unless new_ships.all? { |ship| ship.is_a?(Ship) }

    @ships = new_ships
    @grid = generate_grid
  end

  def receive_shot(shot)
    found_ship = ships.find { |ship| ship.coord_at?(shot.position) }

    if found_ship
      found_ship.hit(shot.position)

      return Constants::HIT
    end

    Constants::MISS
  end

  private

  def generate_grid
    new_grid = create_new_grid

    ships.each do |ship|
      ship.co_ords.each do |co_ords|
        x = co_ords[:x]
        y = co_ords[:y]

        new_grid[y][x] = " #{ship.type_symbol} "
      end
    end

    new_grid
  end

  def check_ship_position(ship)
    if !ship.in_bounds?(GameManager.bounds[:x], GameManager.bounds[:y])
      'Ship out of bounds'
    elsif ship.covers_ship?(@grid)
      'ship collides with existing ships'
    end
  end

  def ships_needed
    ship_count.flat_map do |ship_klass, count|
      klasses = []
      count.times { klasses << ship_klass.new }

      klasses
    end
  end

  def setup_ship(ship)
    valid = false

    until valid
      ship.setup(draw)
      add_ship(ship)

      valid = valid?
      GameManager.clear_screen

      next unless errors.any?

      GameManager.write("#{error_message}\n")

      clear_errors
    end
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
