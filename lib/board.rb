require_relative 'piece'

# Configuration of the board
class Board
  attr_accessor :board, :turn

  def initialize
    @turn = true
    
    @board = []

    8.times do |_i|
      @board.push([nil] * 8)
    end
  end

  def print_board
  end
end

board = Board.new

p board.board[0]