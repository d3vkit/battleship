require_relative 'player_grid'
require_relative 'game_manager'

class Player
  attr_accessor :player_grid, :name

  def initialize(player_number)
    @player_number = player_number
    @player_grid = PlayerGrid.new
    @name = "Player #{player_number}"
  end

  def setup
    @name = GameManager.collect_input("#{@name} Name: ")
    @player_grid.setup
  end

  def start_turn; end
end
