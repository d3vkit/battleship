class TextManager
  def self.colorize(str, color_code)
    "\e[#{color_code}m#{str}\e[0m"
  end

  def self.red(str)
    colorize(str, 31)
  end

  def self.green(str)
    colorize(str, 32)
  end
end