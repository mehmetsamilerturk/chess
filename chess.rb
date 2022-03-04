# frozen_string_literal: true

class Board
  attr_accessor :root_node

  def initialize
    @moves_knight = [[1, 2], [2, 1], [-1, 2], [2, -1], [-2, -1], [-1, -2], [-2, 1], [1, -2]]
    @history = []
    @root_node = nil
  end

  def make_move(position, destination, piece)
    case piece
    when 'knight'
      # update_board method will be used for all of the occurrences here.
      knight_moves(position, destination)
    when 'rook'
      # rook_moves(position, destination)
    when 'bishop'
      # bishop_moves
    when 'queen'
      # queen_moves
    when 'pawn'
      # pawn_moves
    when 'king'
      # king_moves
    end
  end

  def update_board; end

  def knight_moves(position, destination)
    @root_node = Knight.new(position)
    queue = [@root_node]
    current = queue.shift
    @history << current.position
    populate_possible_moves(current, @moves_knight, Knight)

    until current.position == destination
      current.possible_moves.each do |pmove|
        queue << pmove
      end

      current = queue.shift
      @history << current.position
      populate_possible_moves(current, @moves_knight, Knight)
    end

    path = []
    until current.position == @root_node.position
      path.unshift(current.position)
      current = current.parent
    end
    path.unshift(@root_node.position)

    puts "You made it in #{path.size - 1} moves! Here is your path: "
    path.each { |pos| p pos }
  end

  def populate_possible_moves(piece, moves, class_name)
    moves.each do |move|
      next unless (move[0] + piece.position[0]).between?(0, 7) && (move[1] + piece.position[1]).between?(0, 7)

      unless @history.include?(class_name.new([piece.position[0] + move[0], piece.position[1] + move[1]]).position)
        piece.possible_moves << class_name.new([piece.position[0] + move[0], piece.position[1] + move[1]], piece)
      end
    end
  end
end

class Piece
  attr_accessor :position, :possible_moves, :parent

  def initialize(position, parent = nil)
    @position = position
    @possible_moves = []
    @parent = parent
  end
end

class Knight < Piece; end
class Rook < Piece; end
class Bishop < Piece; end
class Queen < Piece; end
class Pawn < Piece; end
class King < Piece; end

board = Board.new

board.make_move([3, 3], [4, 3], 'knight')
