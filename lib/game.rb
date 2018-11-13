require_relative 'game'
require_relative 'game_manager'
require_relative 'player'
require_relative 'text_manager'

class Game
  def initialize
    GameManager.set_proc_title

    game_intro
  end

  def game_intro
    GameManager.instance.waiting = true
    GameManager.clear_screen
    GameManager.write("### BATTLESHIP ###\n\nPRESS ENTER TO BEGIN")

    while GameManager.instance.waiting?
      answer = gets.chomp

      GameManager.instance.waiting = false if answer.empty?
    end

    GameManager.clear_screen

    setup
  end

  def setup
    @waiting = true
    @player1 = Player.new(1)
    @player1.setup

    GameManager.clear_screen

    @player2 = Player.new(2)
    @player2.setup
  end
end
