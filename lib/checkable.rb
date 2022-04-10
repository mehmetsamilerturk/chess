# frozen_string_literal: true

module Checkable
  def check_down(board, i, j)
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

  def check_up(board, i, j)
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

  def check_left(board, i, j)
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

  def check_right(board, i, j)
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

  def check_top_left(board, i, j)
    # lower both column and row. until 0 for both
    piece = board[i][j]
    loop do
      until (i - 1).negative? || (j - 1).negative?
        i -= 1
        j -= 1
        square = board[i][j]
        if piece.white?
          unless square.nil?
            return false if square.white?
            return true if !square.white? && (square.name == 'Q' || square.name == 'B')
          end
        else
          unless square.nil?
            return false unless square.white?
            return true if square.white? && (square.name == 'Q' || square.name == 'B')
          end
        end
      end
      return false
    end
  end

  def check_top_right(board, i, j)
    # increase column, decrease row. column until 7, row until 0
    piece = board[i][j]
    loop do
      until (i - 1).negative? || j + 1 > 7
        i += 1
        j -= 1
        square = board[i][j]
        if piece.white?
          unless square.nil?
            return false if square.white?
            return true if !square.white? && (square.name == 'Q' || square.name == 'B')
          end
        else
          unless square.nil?
            return false unless square.white?
            return true if square.white? && (square.name == 'Q' || square.name == 'B')
          end
        end
      end
      return false
    end
  end

  def check_bottom_left(board, i, j)
    # increase row, decrease column. row until 7, column until 0
    piece = board[i][j]
    loop do
      until i + 1 > 7 || (j - 1).negative?
        i += 1
        j -= 1
        square = board[i][j]
        if piece.white?
          unless square.nil?
            return false if square.white?
            return true if !square.white? && (square.name == 'Q' || square.name == 'B')
          end
        else
          unless square.nil?
            return false unless square.white?
            return true if square.white? && (square.name == 'Q' || square.name == 'B')
          end
        end
      end
      return false
    end
  end

  def check_bottom_right(board, i, j)
    # increase both. both until 7
    piece = board[i][j]
    loop do
      until i + 1 > 7 || j + 1 > 7
        i += 1
        j += 1
        square = board[i][j]
        if piece.white?
          unless square.nil?
            return false if square.white?
            return true if !square.white? && (square.name == 'Q' || square.name == 'B')
          end
        else
          unless square.nil?
            return false unless square.white?
            return true if square.white? && (square.name == 'Q' || square.name == 'B')
          end
        end
      end
      return false
    end
  end

  # true if in check
  def check_diagonal(piece, board)
    i = piece[0]
    j = piece[1]

    if check_top_left(board, i,
                      j) || check_top_right(board, i,
                                            j) || check_bottom_left(board, i, j) || check_bottom_right(board, i, j)
      true
    else
      false
    end
  end

  # true if in check
  def check_straight(piece, board)
    i = piece[0]
    j = piece[1]

    if check_down(board, i, j) || check_up(board, i, j) || check_left(board, i, j) || check_right(board, i, j)
      true
    else
      false
    end
  end
end

# check_straight([7, 4], Board.new.board)
