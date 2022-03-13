require_relative 'board'
require_relative 'color'

# Parent class of all the chess pieces
class Piece
  attr_reader :color, :name

  def initialize
  end

  def is_white?
    # true if white's turn
    @color
  end

  # Return a string to represent the piece
  def to_str
    if @color
      return @name
    else
      return "\033[94m" + @name + "\033[0m"
    end
  end
end

class Rook < Piece
  def initialize(color)
    @color = color
    @name = 'R'
  end

  def is_valid?(board, start, to)

  end
end

class Knight < Piece
  def initialize(color)
    @color = color
    @name = 'N'
  end

  def is_valid?(board, start, to); end
end

class Bishop < Piece
  def initialize(color)
    @color = color
    @name = 'B'
  end

  def is_valid?(board, start, to); end
end

class Queen < Piece
  def initialize(color)
    @color = color
    @name = 'Q'
  end

  def is_valid?(board, start, to); end
end

class King < Piece 
  def initialize(color)
    @color = color
    @name = 'K'
  end

  def is_valid?(board, start, to); end
end

class Pawn < Piece
  def initialize(color)
    @color = color
    @name = 'P'
  end

  def is_valid?(board, start, to); end
end