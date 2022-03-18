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

  def valid?(board, start, to)
    piece = board.board[start[0]][start[1]]
    target = board.board[to[0]][to[1]]
    # If there is no piece in target location
    if target.nil?
      true
    elsif piece.white?
      target.white? ? false : board.captured_pieces[1] << target
    else
      target.white? ? board.captured_pieces[0] << target : false
    end
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

  def valid?(board, start, to)
    if to[0] == start[0] || to[1] == start[1]
      super(board, start, to)
    else
      false
    end
  end
end

class Knight < Piece
  def initialize(color)
    super()
    @color = color
    @name = 'N'
  end

  def valid?(board, start, to)
    if ((to[1] - start[1]).abs == 1 && (to[0] - start[0]).abs == 2) ||
       ((to[1] - start[1]).abs == 2 && (to[0] - start[0]).abs == 1)
      super(board, start, to)
    else
      false
    end
  end
end

class Bishop < Piece
  def initialize(color)
    super()
    @color = color
    @name = 'B'
  end

  def valid?(board, start, to)
    if (to[1] - start[1]).abs == (to[0] - start[0]).abs
      super(board, start, to)
    else
      false
    end
  end
end

class Queen < Piece
  def initialize(color)
    super()
    @color = color
    @name = 'Q'
  end

  def valid?(board, start, to)
    if ((to[0] - start[0]).abs == (to[1] - start[1]).abs) || (to[0] == start[0] || to[1] == start[1])
      super(board, start, to)
    else
      false
    end
  end
end

class King < Piece
  def initialize(color)
    super()
    @color = color
    @name = 'K'
  end

  def valid?(board, start, to)
    if (to[1] - start[1]).abs <= 1 && (to[0] - start[0]).abs <= 1
      super(board, start, to)
    else
      false
    end
  end
end

class Pawn < Piece
  def initialize(color)
    super()
    @color = color
    @name = 'P'
  end

  def valid?(board, start, to)
    if to[1] == start[1] && (to[0] - start[0]).abs == 1
      super(board, start, to)
    else
      false
    end
  end
end
