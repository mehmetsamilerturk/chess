# frozen_string_literal: true

require './lib/chess'

describe Chess do
  describe '#execute' do
    context 'when the king is in check' do
      subject(:game) { described_class.new }

      before do
        allow(game).to receive(:puts)

        game.rboard.board.each_with_index do |array, row|
          array.each_with_index do |square, column|
            game.rboard.board[row][column] = nil if !square.nil? && (square.name == 'P')
          end
        end

        game.rboard.board[6][4] = game.rboard.board[7][3]
        game.rboard.board[7][3] = nil
      end

      it 'outputs an error message when the next move is not valid' do
        piece = game.rboard.board[0][4]
        error_message = 'Your king is in check!'.red
        expect(game).to receive(:puts).with(error_message)
        game.execute([0, 4], [1, 4], true, 'white', piece)
      end

      it 'allows piece to move when the next move is valid' do
        piece = game.rboard.board[0][3]
        game.execute([0, 3], [1, 4], true, 'white', piece)
        expect(game.rboard.board[1][4]).to eq(piece)
      end
    end
  end
end
