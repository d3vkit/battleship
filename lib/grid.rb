require_relative 'game_manager'

class Grid
  def default_grid
    @default_grid ||= Array.new(GameManager.bounds[:y]) { Array.new(GameManager.bounds[:x]) }
  end

  def create_new_grid
    Marshal.load(Marshal.dump(default_grid))
  end
end
