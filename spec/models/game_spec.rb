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
      white_king = game.chess_pieces.where(position_x: 4, position_y: 1).first
      black_king = game.chess_pieces.where(position_x: 4, position_y: 8).last

      expect(white_king.type).to eq 'King'
      expect(white_king.color).to eq 'white'
      expect(black_king.type).to eq 'King'
      expect(black_king.color).to eq 'black'
    end
  end
end
