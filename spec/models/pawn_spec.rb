require 'rails_helper'

RSpec.describe Pawn do
  let(:pawn) { create(:pawn, position_x: 4, position_y: 4, color: :white) }

  it 'has type of Pawn' do
    expect(subject.type).to eq 'Pawn'
  end

  describe 'valid_move?' do
    context 'when color is white' do
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

      it 'returns true for en passant captures' do
        other_pawn = create(:pawn, position_x: 5, position_y: 6, color: :black, game: pawn.game)
        pawn.move_to!(Coordinates.new(4, 6))

        expect(other_pawn.valid_move?(Coordinates.new(4, 5))).to eq true
      end

      it 'only allows en passant captures on the next move' do
        other_pawn = create(:pawn, position_x: 5, position_y: 7, color: :black, game: pawn.game)
        pawn.move_to!(Coordinates.new(4, 6))
        other_pawn.move_to!(Coordinates.new(5, 6))

        expect(other_pawn.valid_move?(Coordinates.new(4, 5))).to eq false
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

  describe '#move_to!' do
    it 'updates game.en_passant_position when doing 2 step moves' do
      pawn.move_to!(Coordinates.new(4, 6))

      expect(pawn.game.en_passant_position).to eq '4,5'
    end

    it 'does not set en_passant_position for 1 step moves' do
      pawn.move_to!(Coordinates.new(4, 5))

      expect(pawn.game.en_passant_position).to eq nil
    end

    it 'allows capturing en passant' do
      other_pawn = create(:pawn, position_x: 5, position_y: 6, color: :black, game: pawn.game)

      pawn.move_to!(Coordinates.new(4, 6))
      other_pawn.move_to!(Coordinates.new(4, 5))

      expect(Pawn.find_by(id: pawn.id)).to be_nil
    end
  end
end
