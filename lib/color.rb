class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end

  def bg_red
    colorize(41)
  end

  def bg_green
    colorize(42)
  end

  def bg_blue
    colorize(44)
  end

  def bg_white
    colorize(47)
  end

  def bg_cyan
    colorize(46)
  end

  def bg_magenta
    colorize(45)
  end

  def bg_yellow
    colorize(43)
  end
end
