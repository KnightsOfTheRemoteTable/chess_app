require 'rails_helper'

RSpec.describe Rook do
  it 'has type of Rook' do
    expect(subject.type).to eq 'Rook'
  end

  describe '#valid_move?' do
    let(:rook) { create(:rook, position_x: 5, position_y: 5, color: :white, game: game) }
    let(:game) { create(:game) }

    it 'returns true for vertical moves' do
      expect(rook.valid_move?(Coordinates.new(5, 6))).to eq true
    end

    it 'returns true for horizontal moves' do
      expect(rook.valid_move?(Coordinates.new(4, 5))).to eq true
    end

    it 'returns false for diagonal moves' do
      expect(rook.valid_move?(Coordinates.new(4, 4))).to eq false
    end

    it 'returns false for jagged moves' do
      expect(rook.valid_move?(Coordinates.new(4, 3))).to eq false
    end

    it 'returns false if obstructed' do
      create(:pawn, position_x: 4, position_y: 5, game: rook.game)

      expect(rook.valid_move?(Coordinates.new(3, 5))).to eq false
    end

    it 'returns false if out of bounds' do
      expect(rook.valid_move?(Coordinates.new(13, 5))).to eq false
    end

    it 'returns false if moving to the same square' do
      expect(rook.valid_move?(Coordinates.new(5, 5))).to eq false
    end

    it 'returns false if capturing friendly piece' do
      expect(rook.valid_move?(Coordinates.new(5, 2))).to eq false
    end
  end
end
