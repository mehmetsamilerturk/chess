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

    context 'when castling is not allowed' do
      let(:rook) { board[7][7] }

      context 'when the king that makes the castling move has moved in the game' do
        before do
          subject.execute([7, 4], [7, 3], false, 'black', wking)
          subject.execute([7, 3], [7, 4], false, 'black', wking)
        end

        it 'restricts castling' do
          expect(subject).to receive(:puts).with('INVALID MOVE!'.red)
          subject.execute([7, 4], [7, 6], false, 'black', wking)
          expect(board[7][6]).to be_nil
        end
      end

      context 'when the rook that makes the castling move has moved in the game' do
        before do
          subject.execute([7, 7], [7, 6], false, 'black', rook)
          subject.execute([7, 6], [7, 7], false, 'black', rook)
        end

        it 'restricts castling' do
          expect(subject).to receive(:puts).with('INVALID MOVE!'.red)
          subject.execute([7, 4], [7, 6], false, 'black', wking)
          expect(board[7][6]).to be_nil
          expect(board[7][7]).to eq(rook)
        end
      end

      context 'when the king is in check' do
        before do
          # to not make it mated
          board[6][4] = nil
          subject.rboard.basic_move([0, 0], [7, 2])
        end

        it 'restricts castling' do
          expect(subject).to receive(:puts).with('Your king is in check!'.red)
          subject.execute([7, 4], [7, 6], false, 'black', wking)
          expect(board[7][6]).to be_nil
          expect(board[7][7]).to eq(rook)
        end
      end

      context 'when the king moves over a square that is attacked by an enemy piece during the castling move' do
        before do
          board[6][5] = nil
          subject.rboard.basic_move([0, 0], [4, 5])
        end

        it 'restricts castling' do
          expect(subject).to receive(:puts).with('INVALID MOVE!'.red)
          subject.execute([7, 4], [7, 6], false, 'black', wking)
          expect(board[7][6]).to be_nil
          expect(board[7][7]).to eq(rook)
        end
      end

      context 'when the king moves to a square that is attacked by an enemy piece during the castling move' do
        before do
          board[6][6] = nil
          subject.rboard.basic_move([0, 0], [4, 6])
        end

        it 'restricts castling' do
          expect(subject).to receive(:puts).with('Your king is in check!'.red)
          subject.execute([7, 4], [7, 6], false, 'black', wking)
          expect(board[7][6]).to be_nil
          expect(board[7][7]).to eq(rook)
        end
      end

      context 'when all squares between the rook and king before the castling move are not empty' do
        before do
          subject.rboard.basic_move([7, 0], [7, 5])
        end

        it 'restricts castling' do
          expect(subject).to receive(:puts).with('INVALID MOVE!'.red)
          subject.execute([7, 4], [7, 6], false, 'black', wking)
          expect(board[7][6]).to be_nil
          expect(board[7][7]).to eq(rook)
        end
      end
    end
  end

  describe 'stalemate' do
    context 'when a player cannot make any legal move, but he/she is not in check' do
      before do
        subject.rboard.board.each_with_index do |arr, aindex|
          arr.each_with_index do |square, sindex|
            if !square.nil? && (square.name == 'P' || square.name == 'Q' || square.name == 'N' || square.name == 'B')
              subject.rboard.board[aindex][sindex] = nil
            end
          end
        end

        subject.rboard.basic_move([7, 4], [2, 7])
        subject.rboard.basic_move([7, 0], [2, 6])
        subject.rboard.basic_move([0, 4], [0, 7])
      end

      xit 'ends the game' do
        subject.rboard.print_board
      end

      xit 'declares draw' do
        subject.rboard.print_board
      end
    end
  end

  describe 'mate' do
    context 'when a player is in check, and he cannot make a move such that after the move, the king is not in check' do
      before do
        subject.rboard.board.each_with_index do |arr, aindex|
          arr.each_with_index do |square, sindex|
            if !square.nil? && (square.name == 'P' || square.name == 'Q' || square.name == 'N' || square.name == 'B' || (square.name == 'R' && !square.white?))
              subject.rboard.board[aindex][sindex] = nil
            end
          end
        end

        subject.rboard.basic_move([0, 4], [0, 7])
        subject.rboard.basic_move([7, 7], [0, 4])
        subject.rboard.basic_move([7, 4], [2, 7])
      end

      it 'makes the player mated' do
        expect(subject.rboard.determine_mate([0, 7])).to be true
      end
    end

    context 'when a player is one move away from mate' do
      before do
        allow(subject).to receive(:puts)
        allow(subject).to receive(:print)
        allow(subject.rboard).to receive(:puts)
        allow(subject.rboard).to receive(:print)
        allow(subject).to receive(:gets).and_return('34', '04', '07', '06')

        subject.rboard.board.each_with_index do |arr, aindex|
          arr.each_with_index do |square, sindex|
            if !square.nil? && (square.name == 'P' || square.name == 'Q' || square.name == 'N' || square.name == 'B' || (square.name == 'R' && !square.white?))
              subject.rboard.board[aindex][sindex] = nil
            end
          end
        end

        subject.rboard.basic_move([0, 4], [0, 7])
        subject.rboard.basic_move([7, 7], [3, 4])
        subject.rboard.basic_move([7, 4], [2, 7])
      end

      it 'ends the game' do
        expect(subject).to receive(:over?)
        subject.play
      end
    end
  end
end

# subject.rboard.print_board
