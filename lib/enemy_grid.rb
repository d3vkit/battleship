require_relative 'game_manager'
require_relative 'grid'

class EnemyGrid < Grid
  attr_accessor :shots

  def initialize
    @shots = []
    @grid = generate_grid
  end

  private

  def generate_grid
    new_grid = create_new_grid

    shots.each do |shot|
      shot.co_ords.each do |co_ords|
        x = co_ords[:x]
        y = co_ords[:y]

        new_grid[y][x] = " #{shot.type_symbol} "
      end
    end

    new_grid
  end
end
