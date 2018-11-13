require_relative 'grid'
require_relative 'game_manager'

class Player
  attr_accessor :grid, :name

  def initialize(player_number)
    @player_number = player_number
    @grid = Grid.new
    @name = "Player #{player_number}"
  end

  def setup
    @name = GameManager.collect_input("#{@name} Name: ")
    @grid.setup
  end
end