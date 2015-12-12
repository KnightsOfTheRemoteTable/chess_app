require 'rails_helper'

RSpec.describe Knight do
  it 'has type of Knight' do
    expect(subject.type).to eq 'Knight'
  end

  describe '#valid_move?' do
    let(:knight) { create(:knight, position_x: 4, position_y: 4, game: game, color: :white) }
    let(:game)   { create(:game) }

    it 'returns true if the x and y move components are 1 and 2, respectively' do
      expect(knight.valid_move?(Coordinates.new(5, 6))).to eq true
    end

    it 'returns true if the x and y move components are 2 and 1, respectively' do
      expect(knight.valid_move?(Coordinates.new(6, 5))).to eq true
    end

    it 'returns false if out of bounds' do
      knight = create(:knight, position_x: 7, position_y: 4)
      expect(knight.valid_move?(Coordinates.new(9, 5))).to eq false
    end

    it 'returns false if the king would be put in check' do
      remove_everything_but_king!('black')
      knight = create(:bishop, position_x: 6, position_y: 7, color: 'black', game: game)
      create(:rook, position_x: 5, position_y: 6, color: 'white', game: game)
      expect(knight.valid_move?(Coordinates.new(4, 5))).to eq false
    end

    it 'returns false if moving to the same square' do
      expect(knight.valid_move?(Coordinates.new(4, 4))).to eq false
    end

    it 'returns false if capturing friendly piece' do
      expect(knight.valid_move?(Coordinates.new(5, 2))).to eq false
    end

    it 'returns false otherwise' do
      expect(knight.valid_move?(Coordinates.new(6, 6))).to eq false
    end
  end
end

def remove_everything_but_king!(color)
  Pawn.with_color(color).destroy_all(game: game)
  Knight.with_color(color).destroy_all(game: game)
  Bishop.with_color(color).destroy_all(game: game)
  Queen.with_color(color).destroy_all(game: game)
  Rook.with_color(color).destroy_all(game: game)
end
