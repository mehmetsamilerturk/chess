# frozen_string_literal: true

require_relative 'board'
require_relative 'piece'
require_relative 'color'

# State of the game
class Chess
  attr_accessor :rboard, :over

  def initialize
    @rboard = Board.new
    @over = false
  end

  def over?
    @over
  end

  def check_game_over
    king = if @rboard.turn
             @rboard.board.flatten.find { |square| !square.nil? && square.white? && square.name == 'K' }
           else
             @rboard.board.flatten.find { |square| !square.nil? && !square.white? && square.name == 'K' }
           end

    if king.checked?(@rboard.get_location(king), @rboard.board)
      if @rboard.determine_mate
        puts king.white? ? 'BLACK WINS!' : 'WHITE WINS!'
        @over = true
      else
        false
      end
    elsif @rboard.determine_mate
      puts 'DRAW!'
      @over = true
    else
      false
    end
  end

  def execute(from, to, turn, gcolor, piece)
    if rboard.determine_check(from, to)
      puts
      puts 'Your king is in check!'.red
    elsif piece.valid?(rboard, from, to)
      if rboard.valid?(rboard, from, to)
        rboard.move(from, to)
        rboard.turn = turn
        clean_ghosts(gcolor)
      else
        puts 'ILLEGAL MOVE'.red
      end
    else
      puts 'INVALID MOVE!'.red
    end

    check_game_over
  end

  # game ends after mated player tries to make a move
  def play
    move until @over
  end

  # moving a piece to its destination
  def move
    puts ''
    puts rboard.turn ? 'White\'s turn' : 'Black\'s turn'.blue

    rboard.print_board
    from, to = ask_move
    piece = rboard.board[from[0]][from[1]]

    if rboard.turn
      until piece.white?
        puts
        rboard.print_board
        puts
        puts "#{'WARNING'.red}: White's turn!"
        from, to = ask_move
        piece = rboard.board[from[0]][from[1]]
      end

      execute(from, to, false, 'black', piece)

    else
      while piece.white?
        puts
        rboard.print_board
        puts
        puts "#{'WARNING'.red}: Black's turn!"
        from, to = ask_move
        piece = rboard.board[from[0]][from[1]]
      end

      execute(from, to, true, 'white', piece)
    end
  end

  def ask_move
    puts
    puts 'Your move should be in this format: 34'
    puts '3 is row and 4 is column'

    print 'Enter the location of your piece> '
    location = gets.chomp

    print 'Enter the destination> '
    destination = gets.chomp

    [[location[0].to_i, location[1].to_i], [destination[0].to_i, destination[1].to_i]]
  end

  def clean_ghosts(color)
    @rboard.board.flatten.each do |square|
      unless square.nil?
        # clean white ghost pawns
        if color == 'white'
          @rboard.board[square.location[0]][square.location[1]] = nil if square.ghost? && square.white?
        # clean black ghost pawns
        elsif square.ghost? && !square.white?
          @rboard.board[square.location[0]][square.location[1]] = nil
        end
      end
    end
  end
end

# game = Chess.new
# game.rboard.board.each_with_index do |arr, aindex|
#   arr.each_with_index do |square, sindex|
#     if !square.nil? && (square.name == 'P' || square.name == 'Q' || square.name == 'N' || square.name == 'B')
#       game.rboard.board[aindex][sindex] = nil
#     end
#   end
# end
#
# game.rboard.basic_move([7, 4], [2, 7])
# game.rboard.basic_move([7, 0], [7, 6])
# game.rboard.basic_move([0, 4], [0, 7])
# game.rboard.board[7][7] = nil
# game.rboard.board[0][0] = nil
#
# game.play
