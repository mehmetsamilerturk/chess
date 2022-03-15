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
    rboard.print_board
    from, to = ask_move

    # raise "no move" if ...
    p [from, to]
  end

  def play; end

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

game = Chess.new

game.move
