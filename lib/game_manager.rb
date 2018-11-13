require 'singleton'
require_relative 'input_manager'
require_relative 'text_manager'

class GameManager
  include Singleton

  attr_accessor :waiting

  def initialize
    @waiting = false
  end

  def waiting?
    @waiting
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
end