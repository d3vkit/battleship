class ShipManager
  attr_reader :ships

  def initialize
    @ships = []
  end

  def setup_ship(ship_klass)
    system 'clear'
    
    ship_valid = false
    grid_valid = false
    ship_size = ship_klass::SIZE
    ship_name = ship_klass.to_s.gsub(/(.)([A-Z])/,'\1 \2')

    until ship_valid && grid_valid
      puts "Enter position for #{ship_name} (#{ship_size} spaces)\n"
      puts draw + "\n"

      start_pos = @input_manager.collect_input('Start Position: ')
      end_pos = @input_manager.collect_input('End Position: ')

      ship = ship_klass.new(start_pos, end_pos)
      ship_valid = ship.valid?

      if ship.errors.any?
        puts "#{ship.error_message}\n"
      else
        add_ship(ship)

        grid_valid = valid?

        if self.errors.any?
          puts "#{error_message}\n"

        end
      end
    end

    puts ""
  end

  def ship_count
    @ship_count ||= {
      AircraftCarrier => 1,
      Battleship => 1,
      Cruiser => 1,
      Destroyer => 2,
      Submarine => 2,
    }
  end
end