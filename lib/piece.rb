# frozen_string_literal: true

require_relative 'board'
require_relative 'color'

# Parent class of all the chess pieces
class Piece
  attr_reader :color, :name

  def initialize; end

  def white?
    # true if white's turn
    @color
  end

  # Return a string to represent the piece
  def to_str
    if @color
      @name
    else
      "\e[94m#{@name}\e[0m"
    end
  end
end

class Rook < Piece
  def initialize(color)
    super()
    @color = color
    @name = 'R'
  end

  def valid?(board, start, to); end
end

class Knight < Piece
  def initialize(color)
    super()
    @color = color
    @name = 'N'
  end

  def valid?(board, start, to); end
end

class Bishop < Piece
  def initialize(color)
    super()
    @color = color
    @name = 'B'
  end

  def valid?(board, start, to); end
end

class Queen < Piece
  def initialize(color)
    super()
    @color = color
    @name = 'Q'
  end

  def valid?(board, start, to); end
end

class King < Piece
  def initialize(color)
    super()
    @color = color
    @name = 'K'
  end

  def valid?(_board, start, to)
    to[0].to_i - start[0].to_i <= 1 && to[1].to_i - start[1].to_i <= 1
  end
end

class Pawn < Piece
  def initialize(color)
    super()
    @color = color
    @name = 'P'
  end

  def valid?(board, start, to); end
end
