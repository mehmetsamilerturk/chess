# Parent class of all the chess pieces
class Piece
  attr_reader :color

  def initialize
  end

  def is_valid?
    false
  end

  def is_white?; end

  # Return a string to represent the piece
  def to_str; end
end

class Rook < Piece
  def initialize(color)
    @color = color
  end

  def is_valid?(board, start, to); end
end

class Knight < Piece
  def initialize(color)
    @color = color
  end

  def is_valid?(board, start, to); end
end

class Bishop < Piece
  def initialize(color)
    @color = color
  end

  def is_valid?(board, start, to); end
end

class Queen < Piece
  def initialize(color)
    @color = color
  end

  def is_valid?(board, start, to); end
end

class King < Piece 
  def initialize(color)
    @color = color
  end

  def is_valid?(board, start, to); end
end

class Pawn < Piece
  def initialize(color)
    @color = color
  end

  def is_valid?(board, start, to); end
end

class PawnEnPassant < Piece
  def initialize(color)
    @color = color
  end

  def is_valid?(board, start, to); end
end