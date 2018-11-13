class GridRenderer
  POS_ARR = ('A'..'J').to_a.freeze
  ROW_BORDER = "\n  |---------------------------------------|\n".freeze
  PADDING = '   '.freeze

  def initialize(grid)
    @grid = grid
  end

  def draw
    str = PADDING

    10.times do |n|
      str += n == 9 ? (n + 1).to_s : " #{n + 1}  "
    end

    str += ' '
    str += ROW_BORDER

    @grid.each_with_index do |row, index|
      str += "#{POS_ARR[index]} |"

      row.each do |column|
        str += !column.nil? ? column : PADDING
        str += '|'
      end

      str += ROW_BORDER
    end

    str
  end
end
