require_relative 'game'
require_relative 'game_manager'
require_relative 'player'
require_relative 'text_manager'

class Game
  attr_accessor :player1, :player2

  def initialize
    GameManager.set_proc_title

    @player1 = nil
    @player2 = nil

    game_intro
  end

  def game_intro
    waiting = true
    GameManager.clear_screen
    GameManager.write("### BATTLESHIP ###\n\nPRESS ENTER TO BEGIN")

    while waiting
      answer = gets.chomp

      waiting = false if answer.empty?
    end

    GameManager.clear_screen

    setup
  end

  def setup
    player1 = Player.new(1)
    player1.setup

    GameManager.clear_screen

    player2 = Player.new(2)
    player2.setup

    GameManager.instance.players = [@player1, @player2]

    start_game
  end

  def start_game
    GameManager.clear_screen


  end
end
