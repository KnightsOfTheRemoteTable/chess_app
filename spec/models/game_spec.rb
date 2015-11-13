require 'rails_helper'

RSpec.describe Game do
  it { is_expected.to have_attribute :name }

  it { is_expected.to belong_to :white_player }

  it { is_expected.to belong_to :black_player }

  it { is_expected.to have_many :chess_pieces }

  it { is_expected.to validate_presence_of :name }

  describe 'games#populate_board!' do
    it 'initializes a Black King in correct starting position' do
      game = create(:game)
      black_king = game.chess_pieces.where(position_x: 4, position_y: 0).first

      expect(black_king.type).to eq 'King'
      expect(black_king.color).to eq 'black'
    end

    it 'create White pieces location' do
      game = create(:game)
      correct_positions = [[1,1],[2,1],[3,1],[4,1],[5,1],[6,1],[7,1],[8,1]]
      actual_positions = game.chess_pieces.where(type: 'Pawn').pluck(:position_x, :position_y)
      
    end
  end
end
