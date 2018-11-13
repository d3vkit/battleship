require 'singleton'
require_relative 'input_manager'
require_relative 'text_manager'

class GameManager
  include Singleton
  attr_accessor :turn, :players

  def initialize
    @turn = 0
    @players = []
  end

  def next_turn
    @turn = determine_next_turn
  end

  def start_turn
    # error if no players

    current_player = players[turn]
    opponent = players[determine_next_turn]

    GameManager.write("${current_player.name} Turn\n")
    GameManager.write('Your Ships')

    current_player.grid.draw

    GameManager.write('Enemy Ships')

    opponent.grid.draw(fog_of_war: true)

    # current_player.start_turn
  end

  def self.set_proc_title
    $0 = 'Battleship'
    Process.setproctitle('Battleship')
    system("printf \"\033]0;Battleship\007\"")
  end

  def self.clear_screen
    return if ENV['DEBUG']

    system 'clear'
  end

  def self.write(text, color: nil)
    text = TextManager.public_send(color, text) if color

    puts text
  end

  def self.collect_input(prepend_text = nil)
    InputManager.collect_input(prepend_text)
  end

  def self.quit
    write('Thanks For Playing!', color: 'green')

    exit(true)
  end

  def self.bounds
    { x: 10, y: 10 }
  end

  private

  def determine_next_turn
    turn == 1 ? 0 : 1
  end
end
