# frozen_string_literal: true

require './lib/chess'

describe Chess do
  describe '#execute' do
    context 'when the king is in check' do
      before do
        allow(subject).to receive(:puts)

        subject.rboard.board.each_with_index do |array, row|
          array.each_with_index do |square, column|
            subject.rboard.board[row][column] = nil if !square.nil? && (square.name == 'P')
          end
        end

        subject.rboard.board[6][4] = subject.rboard.board[7][3]
        subject.rboard.board[7][3] = nil
      end

      it 'outputs an error message when the next move is not valid' do
        piece = subject.rboard.board[0][4]
        error_message = 'Your king is in check!'.red
        expect(subject).to receive(:puts).with(error_message)
        subject.execute([0, 4], [1, 4], true, 'white', piece)
      end

      it 'allows piece to move when the next move is valid' do
        piece = subject.rboard.board[0][3]
        subject.execute([0, 3], [1, 4], true, 'white', piece)
        expect(subject.rboard.board[1][4]).to eq(piece)
      end
    end
  end
end
