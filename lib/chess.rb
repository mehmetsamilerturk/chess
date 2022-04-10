# frozen_string_literal: true

require_relative 'board'
require_relative 'piece'
require_relative 'color'

# State of the game
class Chess
  attr_accessor :rboard

  def initialize
    @rboard = Board.new
  end

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
        if rboard.valid?(rboard, from, to)
          rboard.move(from, to)
          rboard.turn = false
          clean_ghosts('black')
        else
          puts 'INVALID MOVE'.red
        end
      else
        puts 'INVALID MOVE!'.red
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
        if rboard.valid?(rboard, from, to)
          rboard.move(from, to)
          rboard.turn = true
          clean_ghosts('white')
        else
          puts 'INVALID MOVE'.red
        end
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

  private

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

# board = Board.new
# p board.board[7][4].valid?(board.board, [7, 4], [4, 4])
# [7] is row and [3] is column
# p board.board[7][3]
# board.print_board
# board.move([6, 2], [5, 2])
# board.print_board

# game.rboard.board.flatten.each do |square|
#   p square if square.ghost? unless square.nil?
# end

game = Chess.new
game.play
