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

describe Knight do
  subject { Chess.new }
  let(:board) { subject.rboard.board }
  let(:knight) { board[7][1] }
  let(:knight_coord) { subject.rboard.get_location(knight) }

  context 'when moving' do
    before do
      allow(subject).to receive(:puts)
    end

    it 'can make a standard knight move' do
      subject.execute(knight_coord, [5, 0], false, 'black', knight)
      expect(board[5][0]).to eq(knight)
    end

    it 'can make another standard knight move' do
      subject.rboard.basic_move(knight_coord, [4, 2])
      subject.execute([4, 2], [3, 4], false, 'black', knight)
    end

    it 'can\'t move straight' do
      expect(subject).to receive(:puts).with('INVALID MOVE!'.red)
      subject.execute(knight_coord, [5, 1], false, 'black', knight)
    end

    it 'can\'t move diagonal' do
      expect(subject).to receive(:puts).with('INVALID MOVE!'.red)
      subject.execute(knight_coord, [5, 3], false, 'black', knight)
    end
  end

  context 'when facing other pieces' do
    before do
      allow(subject).to receive(:puts)
    end

    it 'can jump over other pieces' do
      subject.execute(knight_coord, [5, 2], false, 'black', knight)
      expect(board[5][2]).to eq(knight)
    end

    it 'eats enemy piece' do
      subject.rboard.basic_move(knight_coord, [2, 1])
      target = board[0][2]
      subject.execute([2, 1], [0, 2], false, 'black', knight)
      expect(board[0][2].name).to eq('N')
      expect(subject.rboard.captured_pieces.flatten).to include(target)
    end
  end
end

describe Pawn do
  subject { Chess.new }
  let(:board) { subject.rboard.board }
  let(:wpawn) { board[6][1] }
  let(:wpawn_coord) { subject.rboard.get_location(wpawn) }

  before do
    allow(subject).to receive(:puts)
  end

  context 'when moving to an empty square' do
    context 'when making the first move' do
      it 'can make a double step straight forward' do
        subject.execute(wpawn_coord, [4, 1], false, 'black', wpawn)
        expect(board[4][1]).to eq(wpawn)
      end

      it 'leaves a ghost pawn one step back if double stepped' do
        subject.execute(wpawn_coord, [4, 1], false, 'black', wpawn)
        expect(board[5][1]).to be_ghost
      end

      it 'can be taken by an en-passant move by enemy pawn' do
        bpawn = board[1][2]
        subject.rboard.basic_move([1, 2], [4, 2])
        subject.execute(wpawn_coord, [4, 1], false, 'black', wpawn)
        subject.execute([4, 2], [5, 1], true, 'white', bpawn)

        expect(board[4][1]).to be_nil
        expect(board[5][1]).to eq(bpawn)
        expect(subject.rboard.captured_pieces.flatten).to include(wpawn)
      end

      it 'can\'t be taken by an en-passant move if enemy is not pawn' do
        enemy = board[0][0]
        subject.rboard.basic_move([0, 0], [5, 2])
        subject.execute(wpawn_coord, [4, 1], false, 'black', wpawn)

        expect(subject).to receive(:puts).with('ILLEGAL MOVE'.red)
        subject.execute([5, 2], [5, 1], true, 'white', enemy)

        expect(board[5][2]).to eq(enemy)
        expect(subject.rboard.captured_pieces.flatten).not_to include(wpawn)
      end
    end

    it 'moves one square straight forward' do
      subject.execute(wpawn_coord, [5, 1], false, 'black', wpawn)
      expect(board[5][1]).to eq(wpawn)
    end

    it 'can\'t make a double step forward if it\'s not the first move' do
      subject.execute(wpawn_coord, [5, 1], false, 'black', wpawn)
      subject.execute([5, 1], [3, 1], false, 'black', wpawn)
      expect(board[3][1]).to be_nil
    end

    it 'can\'t move diagonal' do
      subject.execute(wpawn_coord, [5, 2], false, 'black', wpawn)
      expect(board[5][2]).to be_nil
    end

    context 'when reaching the last row of the board' do
      before do
        allow(subject.rboard).to receive(:print)
      end

      it 'promotes to queen by default' do
        board[0][1] = nil

        subject.rboard.basic_move([6, 1], [1, 1])
        subject.execute([1, 1], [0, 1], false, 'black', board[1][1])

        expect(board[0][1].name).to eq('Q')
      end
    end
  end

  context 'when taking a piece of the opponent' do
    it 'can only take diagonals one square away' do
      enemy = board[1][2]
      subject.rboard.basic_move([1, 2], [5, 2])
      subject.execute(wpawn_coord, [5, 2], false, 'black', wpawn)

      expect(board[6][1]).to be_nil
      expect(board[5][2]).to eq(wpawn)
      expect(subject.rboard.captured_pieces.flatten).to include(enemy)
    end

    it 'can\'t take straight' do
      enemy = board[1][2]
      subject.rboard.basic_move([1, 2], [5, 1])
      subject.execute(wpawn_coord, [5, 1], false, 'black', wpawn)

      expect(board[5][1]).to eq(enemy)
      expect(board[6][1]).to eq(wpawn)
      expect(subject.rboard.captured_pieces.flatten).not_to include(enemy)
    end
  end
end

describe King do
  subject { Chess.new }
  let(:board) { subject.rboard.board }
  let(:king) { board[7][4] }
  let(:king_coord) { subject.rboard.get_location(king) }

  before do
    allow(subject).to receive(:puts)
  end

  it 'moves one square in any direction' do
    subject.rboard.basic_move(king_coord, [5, 4])
    subject.execute([5, 4], [4, 4], false, 'black', king)
    expect(board[4][4]).to eq(king)
  end

  it 'can\'t move more than one square' do
    subject.rboard.basic_move(king_coord, [5, 4])
    expect(subject).to receive(:puts).with('INVALID MOVE!'.red)
    subject.execute([5, 4], [3, 4], false, 'black', king)
    expect(board[3][4]).to be_nil
  end
end
