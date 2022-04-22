# frozen_string_literal: true

require './lib/chess'

describe Chess do
  let(:board) { subject.rboard.board }

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

  describe 'castling' do
    let(:wking) { board[7][4] }
    let(:bking) { board[0][4] }

    before do
      allow(subject).to receive(:puts)

      subject.rboard.board.each_with_index do |array, row|
        array.each_with_index do |square, column|
          if !square.nil? && (square.name == 'N' || square.name == 'B' || square.name == 'Q')
            subject.rboard.board[row][column] =
              nil
          end
        end
      end
    end

    context 'when castling is allowed' do
      it 'makes a short castling move' do
        subject.execute([7, 4], [7, 6], false, 'black', wking)
        expect(board[7][6]).to eq(wking)
        expect(board[7][5].name).to eq('R')
      end

      it 'makes a long castling move' do
        subject.execute([7, 4], [7, 2], false, 'black', wking)
        expect(board[7][2]).to eq(wking)
        expect(board[7][3].name).to eq('R')
      end

      it 'makes a short castling move(black)' do
        subject.execute([0, 4], [0, 6], true, 'white', bking)
        expect(board[0][6]).to eq(bking)
        expect(board[0][5].name).to eq('R')
      end

      it 'makes a long castling move(black)' do
        subject.execute([0, 4], [0, 2], true, 'white', bking)
        expect(board[0][2]).to eq(bking)
        expect(board[0][3].name).to eq('R')
      end
    end
  end
end

# subject.rboard.print_board
