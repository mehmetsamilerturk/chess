# frozen_string_literal: true

require_relative 'board'
require_relative 'color'

# contains possible capture moves and normal pawn moves too
def pawn_capture_moves(board, start, to); end

# contains possible en-passant and normal pawn moves too
def en_passant_moves(board, start, to)
  pawn_en = board.board[start[0]][start[1]]
  # target = board.board[to[0]][to[1]]

  if pawn_en.white?
    (to[1] == start[1] && to[0] == start[0] - 2) ||
      (to[1] == start[1] && (to[0] - start[0]).abs == 1)
  else
    (to[1] == start[1] && to[0] == start[0] + 2) ||
      (to[1] == start[1] && (to[0] - start[0]).abs == 1)
  end
end

def check_pawn_backwards(board, start, to)
  pawn = board.board[start[0]][start[1]]
  if pawn.white?
    return false if start[0] < to[0]
  elsif start[0] > to[0]
    return false
  end
  true
end

def check_en_passant(board, start, _to)
  pawn_en = board.board[start[0]][start[1]]

  case start[0]
  when 6
    if pawn_en.white?
      true
    else
      false
    end
  when 1
    return true unless pawn_en.white?

    false
  end
end

# check to see if there is nearby possible capture
def check_pawn_captures(board, start, to)
  board = board.board
  pawn = board[start[0]][start[1]]
  if pawn.white?
    if !board[start[0] - 1][start[1] + 1].nil? && !board[start[0] - 1][start[1] - 1].nil?
      (to[1] == start[1] && (to[0] - start[0]).abs == 1) ||
        ((to[0] == start[0] - 1 && to[1] == start[1] + 1) || (to[0] == start[0] - 1 && to[1] == start[1] - 1))
    elsif !board[start[0] - 1][start[1] + 1].nil?
      (to[1] == start[1] && (to[0] - start[0]).abs == 1) ||
        (to[0] == start[0] - 1 && to[1] == start[1] + 1)
    elsif !board[start[0] - 1][start[1] - 1].nil?
      (to[1] == start[1] && (to[0] - start[0]).abs == 1) ||
        (to[0] == start[0] - 1 && to[1] == start[1] - 1)
    end
  elsif !board[start[0] + 1][start[1] - 1].nil? && !board[start[0] + 1][start[1] + 1].nil?
    (to[1] == start[1] && (to[0] - start[0]).abs == 1) ||
      ((to[0] == start[0] + 1 && to[1] == start[1] - 1) || (to[0] == start[0] + 1 && to[1] == start[1] + 1))
  elsif !board[start[0] + 1][start[1] - 1].nil?
    (to[1] == start[1] && (to[0] - start[0]).abs == 1) ||
      (to[0] == start[0] + 1 && to[1] == start[1] - 1)
  elsif !board[start[0] + 1][start[1] + 1].nil?
    (to[1] == start[1] && (to[0] - start[0]).abs == 1) ||
      (to[0] == start[0] + 1 && to[1] == start[1] + 1)
  end
end

# Parent class of all the chess pieces
class Piece
  attr_reader :color, :name

  def initialize; end

  def white?
    # true if white's turn
    @color
  end

  def valid?(board, start, to)
    if (start[0].between?(0, 7) && start[1].between?(0, 7)) && to[0].between?(0, 7) && to[1].between?(0, 7)
      piece = board.board[start[0]][start[1]]
      target = board.board[to[0]][to[1]]
      # If there is no piece in target location
      if target.nil?
        true
      elsif piece.name == 'P'
        true
      elsif piece.white?
        target.white? ? false : board.captured_pieces[1] << target
      else
        target.white? ? board.captured_pieces[0] << target : false
      end
      true
    else
      puts 'INVALID LOCATION'.red
      false
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
    pawn_en = board.board[start[0]][start[1]]
    target = board.board[to[0]][to[1]]

    return false unless check_pawn_backwards(board, start, to)
    return false unless super(board, start, to)

    if pawn_en.white? && !target.nil?
      return false if target.white?
    elsif !pawn_en.white? && !target.nil?
      return false unless target.white?
    end

    if check_en_passant(board, start, to)
      if check_pawn_captures(board, start, to)
        # return target.white? ? board.captured_pieces[0] << target : board.captured_pieces[1] << target
      end

      en_passant_moves(board, start, to)
    elsif check_pawn_captures(board, start, to)
      # target.white? ? board.captured_pieces[0] << target : board.captured_pieces[1] << target
    elsif to[1] == start[1] && (to[0] - start[0]).abs == 1
      true
    else
      false
    end
  end
end

# if check_pawn_captures(board, start, to)
#  target.white? ? board.captured_pieces[0] << target : board.captured_pieces[1] << target
# else
#  false
# end
#   if start[0] == 6
#     if pawn_en.white?
#       (to[1] == start[1] && to[0] == start[0] + 2) ||
#         (to[1] == start[1] && (to[0] - start[0]).abs == 1)
#     end
#   elsif start[0] == 1
#     unless pawn_en.white?
#       (to[1] == start[1] && to[0] == start[0] - 2) ||
#         (to[1] == start[1] && (to[0] - start[0]).abs == 1)
#     end
#   end
# for white capturing
# board[start[0] - 1][start[1] + 1].nil? && board[start[0] - 1][start[1] - 1].nil?
