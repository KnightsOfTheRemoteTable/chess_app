require 'rails_helper'

RSpec.describe Pawn do
  it 'has type of Pawn' do
    expect(subject.type).to eq 'Pawn'
  end

  describe 'valid_move?' do
    context 'when color is white' do
      let(:pawn) { create(:pawn, position_x: 4, position_y: 4, color: :white) }

      it 'returns true for one step forward moves' do
        expect(pawn.valid_move?(Coordinates.new(4, 5))).to eq true
      end

      it 'returns false for two step forward moves if not first move' do
        pawn.move_to!(Coordinates.new(4, 5))
        expect(pawn.valid_move?(Coordinates.new(4, 7))).to eq false
      end

      it 'returns true for two step forward moves on first move' do
        expect(pawn.valid_move?(Coordinates.new(4, 6))).to eq true
      end

      it 'returns false for three step forward moves' do
        expect(pawn.valid_move?(Coordinates.new(4, 7))).to eq false
      end

      it 'returns false for diagonal moves' do
        expect(pawn.valid_move?(Coordinates.new(5, 5))).to eq false
      end

      it 'returns true for diagonal captures' do
        create(:pawn, position_x: 5, position_y: 5, color: :black, game: pawn.game)
        expect(pawn.valid_move?(Coordinates.new(5, 5))).to eq true
      end

      it 'returns false for backwards moves' do
        expect(pawn.valid_move?(Coordinates.new(4, 3))).to eq false
      end

      it 'returns false when obstructed' do
        create(:pawn, position_x: 4, position_y: 5, game: pawn.game)

        expect(pawn.valid_move?(Coordinates.new(4, 5))).to eq false
      end
    end

    context 'when color is black' do
      let(:pawn) { create(:pawn, position_x: 4, position_y: 5, color: :black) }

      it 'returns true for one step forward moves' do
        expect(pawn.valid_move?(Coordinates.new(4, 4))).to eq true
      end

      it 'returns false for backward moves' do
        expect(pawn.valid_move?(Coordinates.new(4, 6))).to eq false
      end
    end
  end
end
