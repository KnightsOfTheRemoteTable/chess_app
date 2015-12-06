require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  describe 'GET pieces#show' do
    it 'responds successfully with an HTTP 200 status code' do
      game = create(:game)
      piece_id = game.chess_pieces.first.id
      get :show, id: piece_id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT pieces#update' do
    it 'responds successfully with an HTTP 302 status code' do
      black_player = create(:user)
      game = create(:game, black_player: black_player)
      sign_in black_player

      piece_id = game.chess_pieces.find_by(position_x: 1, position_y: 7).id
      put(:update, id: piece_id, piece: { position_x: 1, position_y: 6 })

      expect(response).to have_http_status(302)
    end

    it 'redirects to login if not signed in' do
      game = create(:game)
      piece_id = game.chess_pieces.first.id

      put(:update, id: piece_id, piece: { position_x: 1, position_y: 6 })

      expect(response).to redirect_to new_user_session_path
    end

    it 'returns status unauthorized if not playing game' do
      game = create(:game)
      piece_id = game.chess_pieces.first.id
      sign_in create(:user)
      put(:update, id: piece_id, piece: { position_x: 1, position_y: 6 })

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
