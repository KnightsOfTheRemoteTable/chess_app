require 'rails_helper'

RSpec.describe Game do
  it { is_expected.to have_attribute :name }
  it { is_expected.to validate_presence_of :name }

  it { is_expected.to belong_to :white_player }
  it { is_expected.to belong_to :black_player }

  it { is_expected.to have_many :chess_pieces }

  describe 'games#populate_board!' do
    it 'initializes a Black King in the correct starting position' do
      game         = create(:game)
      black_king   = game.chess_pieces.where(position_x: 4, position_y: 0).first

      expect(black_king.type).to eq 'King'
      expect(black_king.color).to eq 'black'
    end
  end
end
