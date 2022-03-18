# frozen_string_literal: true

require_relative 'board'
require_relative 'color'

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
  # board[start[0] - 1][start[1] + 1].nil? && board[start[0] - 1][start[1] - 1].nil? # white
  # board[start[0] + 1][start[1] - 1] && board[start[0] + 1][start[1] + 1] # black
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
        if check_pawn_captures(board, start, to)
          puts 'inside'
          target.white? ? board.captured_pieces[0] << target : board.captured_pieces[1] << target
        else
          false
        end
      elsif piece.white?
        target.white? ? false : board.captured_pieces[1] << target
      else
        target.white? ? board.captured_pieces[0] << target : false
      end
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
    if check_pawn_captures(board, start, to)
      puts 'inside pawn'
      true
    elsif to[1] == start[1] && (to[0] - start[0]).abs == 1
      if @color == true
        return false if start[0] < to[0]
      elsif start[0] > to[0]
        return false
      end
      # Restrict pawns from going backwards
    else
      false
    end

    super(board, start, to)
  end
end

# for white capturing
# board[start[0] - 1][start[1] + 1].nil? && board[start[0] - 1][start[1] - 1].nil?
