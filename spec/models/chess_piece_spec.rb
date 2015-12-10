require 'rails_helper'

RSpec.describe ChessPiece, type: :model do
  %w(
    type
    position_x
    position_y
    color
  ).each do |attribute|
    it { is_expected.to validate_presence_of attribute }
  end

  it { is_expected.to belong_to :player }

  it { is_expected.to belong_to :game }

  it { is_expected.to define_enum_for :color }

  describe '#obstructed?' do
    let(:game) { create(:game) }
    let(:king) { create(:king, position_x: 4, position_y: 3, game: game) }

    describe 'invalid moves' do
      it 'raises an error if move is not a straight line' do
        expect { king.obstructed?(Coordinates.new(5, 5)) }.to raise_error(ArgumentError)
      end
    end

    describe 'vertical moves' do
      it 'is true when a piece is in the way' do
        create(:pawn, position_x: 4, position_y: 4, game: game)

        expect(king.obstructed?(Coordinates.new(4, 5))).to eq true
      end

      it 'is false when unobstructed' do
        expect(king.obstructed?(Coordinates.new(4, 6))).to eq false
      end
    end

    describe 'horizontal moves' do
      it 'is true when a piece is in the way' do
        create(:pawn, position_x: 5, position_y: 3, game: game)

        expect(king.obstructed?(Coordinates.new(6, 3))).to eq true
      end

      it 'is false when unobstructed' do
        expect(king.obstructed?(Coordinates.new(6, 3))).to eq false
      end
    end

    describe 'diagonal moves' do
      it 'is true when a piece is in the way' do
        create(:pawn, position_x: 5, position_y: 4, game: game)

        expect(king.obstructed?(Coordinates.new(6, 5))).to eq true
      end

      it 'is false when a piece is beside the path' do
        king = create(:king, position_x: 5, position_y: 3, game: game)
        create(:pawn, position_x: 3, position_y: 4, game: game)

        expect(king.obstructed?(Coordinates.new(2, 6))).to eq false
      end

      it 'is false when unobstructed' do
        expect(king.obstructed?(Coordinates.new(6, 5))).to eq false
      end
    end
  end

  describe '#move_to!' do
    let(:piece) { create(:pawn, color: :white) }

    it 'updates piece coordinates' do
      piece.move_to!(Coordinates.new(5, 5))

      expect(piece.position_x).to eq 5
      expect(piece.position_y).to eq 5
    end

    it 'raises an error if there is a piece of the same color there' do
      create(:pawn, color: :white, position_x: 5, position_y: 5, game: piece.game)

      expect { piece.move_to!(Coordinates.new(5, 5)) }.to raise_error(ArgumentError)
      expect(piece.position_x).to eq 1
      expect(piece.position_y).to eq 1
    end

    it 'deletes piece and moves there if destination piece is the opposite color' do
      opposing_piece = create(:pawn, color: :black, position_x: 5, position_y: 5, game: piece.game)

      piece.move_to!(Coordinates.new(5, 5))

      expect(piece.position_x).to eq 5
      expect(piece.position_y).to eq 5
      expect(ChessPiece.find_by(id: opposing_piece.id)).to be_nil
    end
  end

  describe '.with_color' do
    it 'returns pieces of the specified color' do
      pawn = create(:pawn, color: :white)

      expect(ChessPiece.with_color(:white)).to include pawn
    end

    it 'does not return pieces of the opposite color' do
      pawn = create(:pawn, color: :white)

      expect(ChessPiece.with_color(:black)).to_not include pawn
    end
  end
end
