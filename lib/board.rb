# frozen_string_literal: true

require_relative 'piece'
require_relative 'color'

# Configuration of the board
class Board
  attr_accessor :board, :turn, :captured_pieces, :ghost_pawns_white, :ghost_pawns_black

  def initialize
    # true if white's turn
    @turn = true
    @board = fill_board
    # first subarray contains captured white pieces and other captured black pieces
    @captured_pieces = [[], []]
    @ghost_pawns_white = []
    @ghost_pawns_black = []
  end

  def valid?(board, start, to)
    if ((start[0].between?(0, 7) && start[1].between?(0, 7)) && to[0].between?(0, 7) && to[1].between?(0, 7)) &&
       !board.board[start[0]][start[1]].ghost?

      piece = board.board[start[0]][start[1]]
      target = board.board[to[0]][to[1]]

      if piece.name == 'K' && piece.castling
        true
      elsif target.nil?
        true
      elsif target.ghost?
        if piece.name == 'P'
          if piece.white?
            if target.white?
              false
            else
              board.captured_pieces[1] << board.board[target.location[0] + 1][target.location[1]]
              board.board[target.location[0] + 1][target.location[1]] = nil
              true
            end
          elsif target.white?
            board.captured_pieces[0] << board.board[target.location[0] - 1][target.location[1]]
            board.board[target.location[0] - 1][target.location[1]] = nil
            true
          else
            false
          end
        else
          false
        end
      elsif piece.name == 'P'
        return false if to[1] == start[1]

        if piece.white?
          target.white? ? false : board.captured_pieces[1] << target
        else
          target.white? ? board.captured_pieces[0] << target : false
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

  def clear
    @board.each_with_index do |arr, aindex|
      arr.each_with_index do |_square, sindex|
        @board[aindex][sindex] = nil
      end
    end
  end

  def get_location(piece)
    @board.each_with_index do |arr, aindex|
      arr.each_with_index do |square, sindex|
        return [aindex, sindex] if square == piece
      end
    end
  end

  # the direction queen, bishop or rook heading
  def get_direction(start, to)
    if to[1] == start[1]
      if to[0] < start[0]
        'up'
      elsif to[0] > start[0]
        'down'
      end
    elsif to[0] == start[0]
      if to[1] < start[1]
        'left'
      elsif to[1] > start[1]
        'right'
      end
    elsif to[0] > start[0]
      if to[1] < start[1]
        'bottom_left'
      elsif to[1] > start[1]
        'bottom_right'
      end
    elsif to[0] < start[0]
      if to[1] < start[1]
        'top_left'
      elsif to[1] > start[1]
        'top_right'
      end
    end
  end

  def valid_mate(start, to)
    piece = @board[start[0]][start[1]]
    target = @board[to[0]][to[1]]

    if determine_check(start, to)
      false
    elsif piece.basic_valid?(self, start, to)
      if ((start[0].between?(0, 7) && start[1].between?(0, 7)) && to[0].between?(0, 7) && to[1].between?(0, 7)) &&
         !@board[start[0]][start[1]].ghost?
        if target.nil?
          true
        elsif target.ghost?
          if piece.name == 'P'
            if piece.white?
              if target.white?
                false
              else
                true
              end
            elsif target.white?
              true
            else
              false
            end
          else
            false
          end
        elsif piece.name == 'P'
          return false if to[1] == start[1]

          if piece.white?
            target.white? ? false : true
          else
            target.white? ? true : false
          end
        elsif piece.white?
          target.white? ? false : true
        else
          target.white? ? true : false
        end
      else
        false
      end
    end
  end

  def get_piece_coords(start)
    piece = @board[start[0]][start[1]]

    piece_coords = []

    @board.each_with_index do |arr, aindex|
      arr.each_with_index do |square, sindex|
        piece_coords << [aindex, sindex] if !square.nil? && (square.color == piece.color)
      end
    end

    piece_coords
  end

  def check_possible_moves(locations, possible_moves)
    i = 0
    locations.each do |start|
      possible_moves[i].each do |to|
        next if start == to
        return false if valid_mate(start, to)
      end

      i += 1
    end

    true
  end

  def generate_possible_moves(locations)
    possible_moves = []

    board_numbers = [0, 1, 2, 3, 4, 5, 6, 7]
    all_moves = board_numbers.product(board_numbers)

    locations.each do |coord|
      piece = @board[coord[0]][coord[1]]
      piece_moves = []
      all_moves.each do |move|
        piece_moves << move if piece.basic_valid?(self, coord, move)
      end
      piece_moves
      possible_moves << piece_moves
    end

    possible_moves
  end

  # true if mated
  def determine_mate
    king = if @turn
             @board.flatten.find { |square| !square.nil? && square.white? && square.name == 'K' }
           else
             @board.flatten.find { |square| !square.nil? && !square.white? && square.name == 'K' }
           end

    locations = get_piece_coords(get_location(king))
    possible_moves = generate_possible_moves(locations)
    check_possible_moves(locations, possible_moves)
  end

  # returns true if the next move causes king to be in check
  def determine_check(start, to)
    piece = @board[start[0]][start[1]]

    # to not lose the piece
    target = basic_move(start, to)

    king = if piece.white?
             @board.flatten.find { |square| !square.nil? && square.white? && square.name == 'K' }
           else
             @board.flatten.find { |square| !square.nil? && !square.white? && square.name == 'K' }
           end

    # redirect checking to other methods if the move is eating the king
    if king.nil?
      reverse_basic_move(start, to, target)
      return false
    end

    king_coord = get_location(king)
    result = king.checked?(king_coord, @board)

    reverse_basic_move(start, to, target)
    result
  end

  # prints the current state
  def print_board
    buffer = ''
    print ' '
    33.times do |_i|
      buffer += '*'
    end

    puts buffer

    row_number = 0

    @board.size.times do |i|
      tmp_str = '|'

      print row_number
      row_number += 1

      @board[i].each do |j|
        tmp_str += if j.nil? || j.ghost? # Ghost Pawn
                     '   |'
                   elsif j.name.size == 2
                     " #{j.to_str}|"
                   else
                     " #{j.to_str} |"
                   end
      end

      puts tmp_str
    end

    buffer = ''
    print ' '
    33.times do |_i|
      buffer += '*'
    end

    puts buffer
    puts '   0   1   2   3   4   5   6   7'.yellow

    captured_white_pieces = []
    captured_black_pieces = []

    captured_pieces.each do |arr|
      arr.each do |piece|
        piece.white? ? captured_white_pieces << piece.to_str : captured_black_pieces << piece.to_str
      end
    end

    print 'Captured white pieces: '
    captured_white_pieces.each { |pic| print pic }
    print "\nCaptured black pieces: "
    captured_black_pieces.each { |pic| print pic }
    puts
  end

  # check if an en-passant move has been made
  def determine_en_passant(start, to)
    piece = @board[start[0]][start[1]]

    if piece.white? && piece.name == 'P' && start[0] == 6
      to[0] == 4
    elsif !piece.white? && piece.name == 'P' && start[0] == 1
      to[0] == 3
    end
  end

  # Gets the name of the promotion piece and promotes the pawn
  def promote(piece, to)
    print 'Promote to: '

    @board[to[0]][to[1]] = case gets.chomp.downcase
                           when 'r'
                             piece.white? ? Rook.new(true) : Rook.new(false)
                           when 'n'
                             piece.white? ? Knight.new(true) : Knight.new(false)
                           when 'b'
                             piece.white? ? Bishop.new(true) : Bishop.new(false)
                           else
                             piece.white? ? Queen.new(true) : Queen.new(false)
                           end
  end

  def determine_promotion(piece, to)
    if piece.name == 'P'
      to[0] == if piece.white?
                 0
               else
                 7
               end
    end
  end

  # Takes 2 digit numbers as arrays: move([1, 0], [2, 0])
  def move(from, to)
    piece = @board[from[0]][from[1]]

    if determine_en_passant(from, to)
      if piece.white?
        @board[from[0] - 1][from[1]] = Pawn.new(true, true, [from[0] - 1, from[1]])
      else
        @board[from[0] + 1][from[1]] = Pawn.new(false, true, [from[0] + 1, from[1]])
      end

      @ghost_pawn_active = true
    end

    return piece.execute_castling(piece.rook_castling, self) if piece.name == 'K' && piece.castling

    piece.moved = true
    @board[to[0]][to[1]] = @board[from[0]][from[1]]
    @board[from[0]][from[1]] = nil

    promote(piece, to) if determine_promotion(piece, to)
  end

  def basic_move(from, to)
    target = @board[to[0]][to[1]]
    @board[to[0]][to[1]] = @board[from[0]][from[1]]
    @board[from[0]][from[1]] = nil
    target
  end

  def reverse_basic_move(from, to, target)
    @board[from[0]][from[1]] = @board[to[0]][to[1]]
    @board[to[0]][to[1]] = target
  end

  def fill_board
    @board = []
    # full board
    8.times do |_i|
      @board.push([nil] * 8)
    end

    # white
    @board[7][0] = Rook.new(true)
    @board[7][1] = Knight.new(true)
    @board[7][2] = Bishop.new(true)
    @board[7][3] = Queen.new(true)
    @board[7][4] = King.new(true)
    @board[7][5] = Bishop.new(true)
    @board[7][6] = Knight.new(true)
    @board[7][7] = Rook.new(true)

    8.times do |i|
      @board[6][i] = Pawn.new(true)
    end

    # black
    @board[0][0] = Rook.new(false)
    @board[0][1] = Knight.new(false)
    @board[0][2] = Bishop.new(false)
    @board[0][3] = Queen.new(false)
    @board[0][4] = King.new(false)
    @board[0][5] = Bishop.new(false)
    @board[0][6] = Knight.new(false)
    @board[0][7] = Rook.new(false)

    8.times do |i|
      @board[1][i] = Pawn.new(false)
    end

    @board
  end
end
