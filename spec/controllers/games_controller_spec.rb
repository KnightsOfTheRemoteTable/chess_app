require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'games#populate_board!' do
    it 'initializes a Black King in the correct starting position' do
      player_black = create(:user)
      player_white = create(:user)
      game         = Game.create(name: 'test game', white_player: player_white, black_player: player_black)
      black_king   = game.chess_pieces.where(position_x: 4, position_y: 0).first

      expect(black_king.type).to eq 'King'
      expect(black_king.color).to eq 'black'
    end
  end

  describe 'GET games#new' do
    it 'responds successfully with an HTTP 200 status code' do
      get :new
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET games#show' do
    it 'responds successfully with an HTTP 200 status code' do
      get :show
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end
end
