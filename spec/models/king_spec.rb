require 'rails_helper'

RSpec.describe King do
  it 'has type of King' do
    expect(subject.type).to eq 'King'
  end

  describe '#valid_move?' do
    it 'is a public instance method' do
      expect(subject).to respond_to :valid_move?
    end

    context 'when a proposed move is within the movement abilities of the piece' do
      it 'returns true' do
        king = create(:king, position_x: 4, position_y: 4)
        expect(king.valid_move?(5, 5)).to be true
      end
    end

    context 'when a proposed move is not within the movement abilities of the piece' do
      it 'returns false' do
        king = create(:king, position_x: 4, position_y: 4)
        expect(king.valid_move?(6, 6)).to be false
      end
    end
  end
end
