# frozen_string_literal: true

require './lib/chess'

describe Chess do
  let(:rboard) { subject.rboard }

  describe '#execute' do
    let(:gcolor) { 'white' }

    context 'when the king is in check' do
      before do
      end

      it 'outputs an error message' do
        error_message = 'Your king is in check!'
        expect(subject.execute(from, to, turn, gcolor)).to receive(:puts).with(error_message)
      end
    end
  end
end
