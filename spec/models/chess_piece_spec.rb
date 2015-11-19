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
        expect { king.obstructed?(5, 5) }.to raise_error(ArgumentError)
      end
    end

    describe 'vertical moves' do
      it 'is true when a piece is in the way' do
        create(:pawn, position_x: 4, position_y: 4, game: game)

        expect(king.obstructed?(4, 5)).to eq true
      end

      it 'is false when unobstructed' do
        expect(king.obstructed?(4, 6)).to eq false
      end
    end

    describe 'horizontal moves' do
      it 'is true when a piece is in the way' do
        create(:pawn, position_x: 5, position_y: 3, game: game)

        expect(king.obstructed?(6, 3)).to eq true
      end

      it 'is false when unobstructed' do
        expect(king.obstructed?(6, 3)).to eq false
      end
    end

    describe 'diagonal moves' do
      it 'is true when a piece is in the way' do
        create(:pawn, position_x: 5, position_y: 4, game: game)

        expect(king.obstructed?(6, 5)).to eq true
      end

      it 'is false when unobstructed' do
        expect(king.obstructed?(6, 5)).to eq false
      end
    end
  end
end
