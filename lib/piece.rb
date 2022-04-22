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
    to[0] == start[0] || to[1] == start[1]
  end
end

class Knight < Piece
  def initialize(color)
    super(color)
    @name = 'N'
  end

  def valid?(_board, start, to)
    ((to[1] - start[1]).abs == 1 && (to[0] - start[0]).abs == 2) ||
      ((to[1] - start[1]).abs == 2 && (to[0] - start[0]).abs == 1)
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
    ((to[0] - start[0]).abs == (to[1] - start[1]).abs) || (to[0] == start[0] || to[1] == start[1])
  end
end

class King < Piece
  attr_accessor :castling, :rook_castling

  def initialize(color)
    super(color)
    @name = 'K'
    @castling = false
    @rook_castling = nil
  end

  def valid?(board, start, to)
    rook = if to[1] == 2
             white? ? board.board[7][0] : board.board[0][0]
           else
             white? ? board.board[7][7] : board.board[0][7]
           end

    if (!rook.nil? && to[1] == 2 || to[1] == 6) && castle?(rook, board)
      @rook_castling = rook
      return @castling = true
    end

    (to[1] - start[1]).abs <= 1 && (to[0] - start[0]).abs <= 1
  end

  def execute_castling(rook, board)
    king_coord = board.get_location(self)
    rook_coord = board.get_location(rook)

    if white?
      if (rook_coord[1]).zero?
        board.board[7][2] = self
        board.board[7][3] = rook
      else
        board.board[7][6] = self
        board.board[7][5] = rook
      end
    elsif (rook_coord[1]).zero?
      board.board[0][2] = self
      board.board[0][3] = rook
    else
      board.board[0][6] = self
      board.board[0][5] = rook
    end
    board.board[king_coord[0]][king_coord[1]] = nil
    board.board[rook_coord[0]][rook_coord[1]] = nil
  end

  # true if available
  def castle?(rook, board)
    king_coord = board.get_location(self)
    rook_coord = board.get_location(rook)

    !rook.moved? && !moved? && !checked?(king_coord,
                                         board.board) && check_empty(rook_coord,
                                                                     board.board) && check_move_over(rook_coord,
                                                                                                     king_coord, board.board)
  end

  # piece = [0, 0] board = Board.new.board
  # returns true if in check
  def checked?(piece, board)
    if check_straight(piece, board)
      # puts 'straight'
      return true
    elsif check_diagonal(piece, board)
      # puts 'diagonal'
      return true
    elsif check_pawns(piece, board)
      # puts 'pawn'
      return true
    elsif check_king(piece, board)
      # puts 'king'
      return true
    elsif check_knights(piece, board)
      # puts 'knight'
      return true
    end

    false
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
