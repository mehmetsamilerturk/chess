# frozen_string_literal: true

require_relative 'movable'
require_relative 'color'
require_relative 'checkable'

# Parent class of all the chess pieces
class Piece
  include Movable
  include Checkable

  attr_accessor :location
  attr_reader :color, :name
  attr_writer :moved

  def initialize(color)
    @color = color
    @moved = false
  end

  def ghost?
    # true if ghost
    @ghost
  end

  def moved?
    # true if moved
    @moved
  end

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
    super(color)
    @name = 'R'
  end

  def valid?(_board, start, to)
    if to[0] == start[0] || to[1] == start[1]
      true
    else
      false
    end
  end
end

class Knight < Piece
  def initialize(color)
    super(color)
    @name = 'N'
  end

  def valid?(_board, start, to)
    if ((to[1] - start[1]).abs == 1 && (to[0] - start[0]).abs == 2) ||
       ((to[1] - start[1]).abs == 2 && (to[0] - start[0]).abs == 1)
      true
    else
      false
    end
  end
end

class Bishop < Piece
  def initialize(color)
    super(color)
    @name = 'B'
  end

  def valid?(_board, start, to)
    (to[1] - start[1]).abs == (to[0] - start[0]).abs
  end
end

class Queen < Piece
  def initialize(color)
    super(color)
    @name = 'Q'
  end

  def valid?(_board, start, to)
    if ((to[0] - start[0]).abs == (to[1] - start[1]).abs) || (to[0] == start[0] || to[1] == start[1])
      true
    else
      false
    end
  end
end

class King < Piece
  def initialize(color)
    super(color)
    @name = 'K'
  end

  def valid?(_board, start, to)
    if (to[1] - start[1]).abs <= 1 && (to[0] - start[0]).abs <= 1
      true
    else
      false
    end
  end

  def checked?(piece, board)
    board = board.board

    # Straight lines
    check_straight(piece, board)

    # Diagonals
    check_diagonal(piece, board)

    # Pawns
    check_pawns(piece, board)

    # King

    # Knights
  end
end

class Pawn < Piece
  attr_writer :ghost

  def initialize(color, ghost = false, location = nil)
    @color = color
    @ghost = ghost
    @name = 'P'
    @location = location
  end

  def valid?(board, start, to)
    pawn_en = board.board[start[0]][start[1]]
    target = board.board[to[0]][to[1]]

    return false unless check_pawn_backwards(board, start, to)

    if pawn_en.white? && !target.nil?
      return false if target.white?
    elsif !pawn_en.white? && !target.nil?
      return false unless target.white?
    end

    if check_en_passant(board, start, to)
      if check_pawn_captures(board, start, to)
        return en_passant_moves(board, start, to) || pawn_capture_moves(board, start, to)
      end

      en_passant_moves(board, start, to)
    elsif check_pawn_captures(board, start, to)
      pawn_capture_moves(board, start, to)
    elsif to[1] == start[1] && (to[0] - start[0]).abs == 1
      true
    else
      false
    end
  end
end
