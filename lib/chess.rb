# frozen_string_literal: true

require_relative 'board'
require_relative 'piece'
require_relative 'color'

# State of the game
class Chess
  attr_reader :rboard

  def initialize
    @rboard = Board.new
  end

  # promotes a Pawn that has reached the end of the board
  def promotion; end

  # moving a piece to its destination
  def move
    puts ''
    puts rboard.turn ? 'White\'s turn' : 'Black\'s turn'.blue

    rboard.print_board
    from, to = ask_move
    piece = rboard.board[from[0]][from[1]]

    # raise "no move" if ...
    if rboard.turn
      until piece.white?
        puts
        rboard.print_board
        puts
        puts "#{'WARNING'.red}: White's turn!"
        from, to = ask_move
        piece = rboard.board[from[0]][from[1]]
      end

      if piece.valid?(rboard, from, to)
        rboard.move(from, to)
        rboard.turn = false
      else
        puts 'INVALID MOVE'.red
      end
    else
      while piece.white?
        puts
        rboard.print_board
        puts
        puts "#{'WARNING'.red}: Black's turn!"
        from, to = ask_move
        piece = rboard.board[from[0]][from[1]]
      end

      if piece.valid?(rboard, from, to)
        rboard.move(from, to)
        rboard.turn = true
      else
        puts 'INVALID MOVE'.red
      end
    end
  end

  # game loop
  def play
    loop do
      move
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
end

# board = Board.new
# p board.board[7][4].valid?(board.board, [7, 4], [4, 4])
# [7] is row and [3] is column
# p board.board[7][3]
# board.print_board
# board.move([6, 2], [5, 2])
# board.print_board

game = Chess.new

game.play
