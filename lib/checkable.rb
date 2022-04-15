# frozen_string_literal: true

# methods to check if the king is in check
module Checkable
  def check_down(board, i, j)
    piece = board[i][j]
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

    false
  end

  def check_up(board, i, j)
    piece = board[i][j]

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
    false
  end

  def check_left(board, i, j)
    piece = board[i][j]

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
    false
  end

  def check_right(board, i, j)
    piece = board[i][j]

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
    false
  end

  def check_top_left(board, i, j)
    # lower both column and row. until 0 for both
    piece = board[i][j]

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
    false
  end

  def check_top_right(board, i, j)
    # increase column, decrease row. column until 7, row until 0
    piece = board[i][j]

    until (i - 1).negative? || j + 1 > 7
      i -= 1
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
    false
  end

  def check_bottom_left(board, i, j)
    # increase row, decrease column. row until 7, column until 0
    piece = board[i][j]

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
    false
  end

  def check_bottom_right(board, i, j)
    # increase both. both until 7
    piece = board[i][j]

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
    false
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

  def check_pawns(piece, board)
    i = piece[0]
    j = piece[1]
    king = board[i][j]

    if king.white?
      wdanger1 = board[i - 1][j - 1]
      wdanger2 = board[i - 1][j + 1]
      return true if !wdanger1.nil? && (!wdanger1.white? && wdanger1.name == 'P')
      return true if !wdanger2.nil? && (!wdanger2.white? && wdanger2.name == 'P')
    else
      bdanger1 = board[i + 1][j - 1]
      bdanger2 = board[i + 1][j + 1]
      return true if !bdanger1.nil? && (!bdanger1.white? && bdanger1.name == 'P')
      return true if !bdanger2.nil? && (!bdanger2.white? && bdanger2.name == 'P')
    end
    false
  end

  def check_king(piece, board)
    i = piece[0]
    j = piece[1]
    king = board[i][j]

    if (i - 1).negative?
      danger1 = nil
      danger2 = nil
      danger3 = nil
    else
      danger1 = board[i - 1][j - 1]
      danger2 = board[i - 1][j]
      danger3 = board[i - 1][j + 1]
    end

    if board[i].nil?
      danger4 = nil
      danger5 = nil
    else
      danger4 = board[i][j - 1]
      danger5 = board[i][j + 1]
    end

    if board[i + 1].nil?
      danger6 = nil
      danger7 = nil
      danger8 = nil
    else
      danger6 = board[i + 1][j - 1]
      danger7 = board[i + 1][j]
      danger8 = board[i + 1][j + 1]
    end

    dangers = [danger1, danger2, danger3, danger4, danger5, danger6, danger7, danger8]

    dangers.each do |danger|
      if king.white?
        return true if !danger.nil? && (!danger.white? && danger.name == 'K')
      elsif !danger.nil? && (danger.white? && danger.name == 'K')
        return true
      end
    end

    false
  end

  def check_knights(piece, board)
    i = piece[0]
    j = piece[1]
    king = board[i][j]

    if (i - 2).negative?
      danger1 = nil
      danger2 = nil
    else
      danger1 = board[i - 2][j - 1]
      danger2 = board[i - 2][j + 1]
    end

    if (i - 1).negative?
      danger3 = nil
      danger4 = nil
    else
      danger3 = board[i - 1][j - 2]
      danger4 = board[i - 1][j + 2]
    end

    if (i + 2) > 7
      danger5 = nil
      danger6 = nil
    else
      danger5 = board[i + 2][j - 1]
      danger6 = board[i + 2][j + 1]
    end

    if (i + 1) > 7
      danger7 = nil
      danger8 = nil
    else
      danger7 = board[i + 1][j - 2]
      danger8 = board[i + 1][j + 2]
    end

    dangers = [danger1, danger2, danger3, danger4, danger5, danger6, danger7, danger8]
    dangers.each do |danger|
      if king.white?
        return true if !danger.nil? && (!danger.white? && danger.name == 'N')
      elsif !danger.nil? && (danger.white? && danger.name == 'N')
        p dangers
        return true
      end
    end

    false
  end

  def check_empty(rook_coord, board)
    # left rook
    if (rook_coord[1]).zero?
      i = 1
      until i > 3
        square = board[7][i]
        return false unless square.nil?

        i += 1
      end
    # right rook
    else
      i = 5
      until i > 6
        square = board[7][i]
        return false unless square.nil?

        i += 1
      end
    end

    true
  end

  def check_move_over(rook_coord, king_coord, board)
    king = board[king_coord[0]][king_coord[1]]
    # left rook
    if (rook_coord[1]).zero?
      i = 2
      until i > 3
        board[7][i] = king
        return false if board[7][i].checked?

        board[7][i] = nil
        i += 1
      end
    # right rook
    else
      i = 5
      until i > 6
        board[7][i] = king
        return false if board[7][i].checked?

        board[7][i] = nil
        i += 1
      end
    end

    true
  end
end

# check_straight([7, 4], Board.new.board)
