class GridRenderer
  POS_ARR = ('A'..'J').to_a.freeze

  def initialize(grid)
    @grid = grid
  end

  def draw
    str = "#{padding}#{column_border}#{row_border}"

    @grid.each_with_index do |row, index|
      str += "#{POS_ARR[index]} |"

      row.each do |column|
        str += column_contents(column)
      end

      str += row_border
    end

    str
  end

  private

  def padding
    '   '
  end

  def row_border
    "\n  |---------------------------------------|\n"
  end

  def column_border
    str = ''

    10.times do |n|
      str += n == 9 ? (n + 1).to_s : " #{n + 1}  "
    end

    str
  end

  def column_contents(column)
    "#{!column.nil? ? column : padding}|"
  end
end
