require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  describe 'GET pieces#show' do
    before do
      @black_player = create(:user)
      @game = create(:game, black_player: @black_player)
    end

    it 'responds successfully with an HTTP 200 status code' do
      sign_in @black_player
      piece_id = @game.chess_pieces.find_by(position_x: 1, position_y: 7)
      get :show, id: piece_id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'redirects to login if not signed in' do
      piece_id = @game.chess_pieces.first.id
      get :show, id: piece_id

      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'PUT pieces#update' do
    let(:game) { create(:game) }

    it 'responds successfully with an HTTP 302 status code' do
      black_player = create(:user)
      game = create(:game, black_player: black_player)
      sign_in black_player

      piece_id = game.chess_pieces.find_by(position_x: 1, position_y: 7).id
      put(:update, id: piece_id, piece: { position_x: 1, position_y: 6 })

      expect(response).to have_http_status(302)
    end

    it 'redirects to login if not signed in' do
      piece_id = game.chess_pieces.first.id
      put(:update, id: piece_id, piece: { position_x: 1, position_y: 6 })

      expect(response).to redirect_to new_user_session_path
    end

    it 'returns status unauthorized if not playing game' do
      piece_id = game.chess_pieces.first.id
      sign_in create(:user)
      put(:update, id: piece_id, piece: { position_x: 1, position_y: 6 })

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns status forbidden for invalid moves' do
      black_player = create(:user)
      game = create(:game, black_player: black_player)
      sign_in black_player

      piece_id = game.chess_pieces.find_by(position_x: 1, position_y: 7).id
      put(:update, id: piece_id, piece: { position_x: 2, position_y: 6 })

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'GET pieces#valid_moves' do
    it 'returns valid moves for the piece' do
      pawn = create(:game).chess_pieces.find_by(position_x: 1, position_y: 2)
      sign_in pawn.game.white_player

      get :valid_moves, id: pawn

      expect(JSON.parse(response.body)).to include('x' => 1, 'y' => 3)
    end
  end
end
