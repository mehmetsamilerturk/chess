# frozen_string_literal: true

require_relative 'piece'
require_relative 'color'

# Configuration of the board
class Board
  attr_accessor :board, :turn

  def initialize
    # true if white's turn
    # @turn = true
    @board = fill_board
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
        tmp_str += if j.nil? || j.name == 'PEP' # Ghost Pawn
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
  end

  # Takes 2 digit numbers as arrays: move([1, 0], [2, 0])
  def move(from, to)
    @board[to[0]][to[1]] = @board[from[0]][from[1]]
    @board[from[0]][from[1]] = nil
  end

  private

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
