require 'singleton'
require_relative 'game_manager'

class InputManager
  include Singleton

  EXIT_WORDS = %w(q quit exit)

  def self.collect_input(prepend_text = nil)
    input = ''

    while input == ''
      if prepend_text
        print prepend_text
      end

      input = gets.chomp

      if input == ''
        GameManager.write('Invalid input, please try again', 'red')
      end
    end

    if EXIT_WORDS.include?(input)
      GameManager.quit
    end

    input
  end
end