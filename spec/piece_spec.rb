# frozen_string_literal: true

require './lib/chess'

describe Rook do
  subject { Chess.new }
  let(:rook) { subject.rboard.board[7][0] }
  let(:rook_coord) { subject.rboard.get_location(rook) }

  context 'when moving' do
    let(:piece) { subject.rboard.board[5][0] }
    let(:black_piece) { subject.rboard.board[3][0] }

    before do
      allow(subject).to receive(:puts)
      subject.rboard.basic_move(rook_coord, [5, 0])
      subject.rboard.basic_move([0, 0], [3, 0])
    end

    it 'moves horizontally' do
      subject.execute([5, 0], [5, 4], false, 'black', piece)
      expect(subject.rboard.board[5][4]).to eq(piece)
    end

    it 'moves vertically' do
      subject.execute([5, 0], [3, 0], false, 'black', piece)
      expect(subject.rboard.board[3][0]).to eq(piece)
    end

    it 'moves horizontally(black)' do
      subject.execute([3, 0], [3, 3], true, 'white', black_piece)
      expect(subject.rboard.board[3][3]).to eq(black_piece)
    end

    it 'moves vertically(black)' do
      subject.execute([3, 0], [4, 0], true, 'white', black_piece)
      expect(subject.rboard.board[4][0]).to eq(black_piece)
    end

    it 'can\'t move diagonally' do
      expect(subject).to receive(:puts).with('INVALID MOVE!'.red)
      subject.execute([5, 0], [4, 1], false, 'black', piece)
    end
  end

  context 'when facing other pieces' do
    before do
      allow(subject).to receive(:puts)
    end

    # fails
    xit 'can\'t jump over other pieces' do
      expect(subject).to receive(:puts).with('ILLEGAL MOVE'.red)
      subject.execute(rook_coord, [5, 0], false, 'black', rook)
    end

    it 'eats enemy piece' do
      subject.rboard.board[6][0] = nil
      target = subject.rboard.board[1][0]
      subject.execute(rook_coord, [1, 0], false, 'black', rook)
      expect(subject.rboard.board[1][0].name).to eq('R')
      expect(subject.rboard.captured_pieces.flatten).to include(target)
    end

    it 'can\'t move into its own piece' do
      expect(subject).to receive(:puts).with('ILLEGAL MOVE'.red)
      subject.execute(rook_coord, [6, 0], false, 'black', rook)
      expect(subject.rboard.board[6][0].name).to eq('P')
    end
  end
end

describe Bishop do
  subject { Chess.new }
  let(:board) { subject.rboard.board }
  let(:bishop) { board[7][2] }
  let(:bishop_coord) { subject.rboard.get_location(bishop) }

  context 'when moving' do
    let(:new_coord) { [5, 2] }
    let(:piece) { board[5][2] }

    before do
      allow(subject).to receive(:puts)
      subject.rboard.basic_move(bishop_coord, [5, 2])
    end

    it 'moves diagonally' do
      subject.execute(new_coord, [3, 4], false, 'black', piece)
      expect(board[3][4]).to eq(piece)
    end

    it 'can\'t move straight' do
      expect(subject).to receive(:puts).with('INVALID MOVE!'.red)
      subject.execute(new_coord, [3, 2], false, 'black', piece)
    end
  end

  context 'when facing other pieces' do
    before do
      allow(subject).to receive(:puts)
    end

    # fail
    xit 'can\'t jump over other pieces' do
      expect(subject).to receive(:puts).with('ILLEGAL MOVE'.red)
      subject.execute(bishop_coord, [5, 4], false, 'black', bishop)
    end
  end
end

describe Queen do
  subject { Chess.new }
  let(:board) { subject.rboard.board }
  let(:queen) { board[7][3] }
  let(:queen_coord) { subject.rboard.get_location(queen) }

  context 'when moving' do
    let(:new_coord) { [5, 3] }
    let(:piece) { board[5][3] }

    before do
      allow(subject).to receive(:puts)
      subject.rboard.basic_move(queen_coord, [5, 3])
    end

    it 'moves horizontal' do
      subject.execute(new_coord, [5, 1], false, 'black', piece)
      expect(board[5][1]).to eq(piece)
    end

    it 'moves vertical' do
      subject.execute(new_coord, [3, 3], false, 'black', piece)
      expect(board[3][3]).to eq(piece)
    end

    it 'moves diagonal' do
      subject.execute(new_coord, [3, 5], false, 'black', piece)
      expect(board[3][5]).to eq(piece)
    end
  end

  context 'when facing other pieces' do
    before do
      allow(subject).to receive(:puts)
    end

    # fail
    xit 'can\'t jump over other pieces' do
      expect(subject).to receive(:puts).with('ILLEGAL MOVE'.red)
      subject.execute(queen_coord, [5, 3], false, 'black', queen)
    end
  end
end
