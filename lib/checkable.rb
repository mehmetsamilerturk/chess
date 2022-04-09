# frozen_string_literal: true

module Checkable
  def check_down(piece, board, i, j)
    piece = board[i][j]
    loop do
      until i + 1 > 7
        i += 1
        square = board[i][j]
        if piece.white?
          unless square.nil?
            return false if square.white?
            return true if !square.white? && (square.name == 'Q' || square.name == 'R')
          end
        else
          unless square.nil?
            return false unless square.white?
            return true if square.white? && (square.name == 'Q' || square.name == 'R')
          end
        end
      end
      return false
    end
  end

  def check_up(piece, board, i, j)
    piece = board[i][j]
    loop do
      until (i - 1).negative?
        i -= 1
        square = board[i][j]
        unless square.nil?
          if piece.white?
            return false if square.white?
            return true if !square.white? && (square.name == 'Q' || square.name == 'R')
          else
            return false unless square.white?
            return true if square.white? && (square.name == 'Q' || square.name == 'R')
          end
        end
      end
      return false
    end
  end

  def check_left(piece, board, i, j)
    piece = board[i][j]
    loop do
      until (j - 1).negative?
        j -= 1
        square = board[i][j]
        if piece.white?
          unless square.nil?
            return false if square.white?
            return true if !square.white? && (square.name == 'Q' || square.name == 'R')
          end
        else
          unless square.nil?
            return false unless square.white?
            return true if square.white? && (square.name == 'Q' || square.name == 'R')
          end
        end
      end
      return false
    end
  end

  def check_right(piece, board, i, j)
    piece = board[i][j]
    loop do
      until j + 1 > 7
        j += 1
        square = board[i][j]
        if piece.white?
          unless square.nil?
            return false if square.white?
            return true if !square.white? && (square.name == 'Q' || square.name == 'R')
          end
        else
          unless square.nil?
            return false unless square.white?
            return true if square.white? && (square.name == 'Q' || square.name == 'R')
          end
        end
      end
      return false
    end
  end

  # true if in check
  def check_straight(piece, board)
    i = piece[0]
    j = piece[1]

    if check_down(piece, board, i,
                  j) || check_up(piece, board, i,
                                 j) || check_left(piece, board, i, j) || check_right(piece, board, i, j)
      true
    else
      false
    end
  end
end

# check_straight([7, 4], Board.new.board)
