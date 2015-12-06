require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'GET games#new' do
    it 'responds successfully with an HTTP 200 status code' do
      sign_in create(:user)
      get :new

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET games#show' do
    it 'responds successfully with an HTTP 200 status code' do
      game = create(:game)
      get :show, id: game

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT games#forfeit' do
    it 'sets the opposite player as the winner' do
      black_player = create(:user)
      white_player = create(:user)
      game = create(:game, black_player: black_player, white_player: white_player)
      sign_in black_player

      put :forfeit, id: game

      expect(response).to redirect_to game
      expect(game.reload.winner).to eq white_player
    end

    it 'redirects to login if not signed in' do
      game = create(:game)

      put :forfeit, id: game

      expect(response).to redirect_to new_user_session_path
      expect(game.reload.winner).to be_nil
    end

    it 'returns status unauthorized if not playing game' do
      game = create(:game)

      sign_in create(:user)
      put :forfeit, id: game

      expect(response).to have_http_status(:unauthorized)
      expect(game.reload.winner).to be_nil
    end
  end
end
