# frozen_string_literal: true

module Movable
  # contains possible capture moves and normal pawn moves too
  def pawn_capture_moves(board, start, to)
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
      else
        false
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
    else
      false
    end
  end

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
  def check_pawn_captures(board, start, _to)
    board = board.board
    pawn = board[start[0]][start[1]]
    if pawn.white?
      if !board[start[0] - 1][start[1] + 1].nil? && !board[start[0] - 1][start[1] - 1].nil?
        true
      elsif !board[start[0] - 1][start[1] + 1].nil?
        true
      elsif !board[start[0] - 1][start[1] - 1].nil?
        true
      else
        false
      end
    elsif !board[start[0] + 1][start[1] - 1].nil? && !board[start[0] + 1][start[1] + 1].nil?
      true
    elsif !board[start[0] + 1][start[1] - 1].nil?
      true
    elsif !board[start[0] + 1][start[1] + 1].nil?
      true
    else
      false
    end
  end
end
