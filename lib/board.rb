require_relative 'piece'

# Configuration of the board
class Board
  attr_accessor :board, :turn

  def initialize
    @turn = true
    white_en_passant_piece = []
    black_en_passant_piece = []
    @board = []

    # full board
    8.times do |_i|
      @board.push([nil] * 8)
    end

    # white
    @board[7][0] = Rook.new('white')
    @board[7][1] = Knight.new('white')
    @board[7][2] = Bishop.new('white')
    @board[7][3] = Queen.new('white')
    @board[7][4] = King.new('white')
    @board[7][5] = Bishop.new('white')
    @board[7][6] = Knight.new('white')
    @board[7][7] = Rook.new('white')

    8.times do |i|
      @board[6][i] = Pawn.new('white')
    end

    # black
    @board[0][0] = Rook.new('black')
    @board[0][1] = Knight.new('black')
    @board[0][2] = Bishop.new('black')
    @board[0][3] = Queen.new('black')
    @board[0][4] = King.new('black')
    @board[0][5] = Bishop.new('black')
    @board[0][6] = Knight.new('black')
    @board[0][7] = Rook.new('black')

    8.times do |i|
      @board[1][i] = Pawn.new('black')
    end
  end

  def print_board
  end
end

board = Board.new

p board.board[0]