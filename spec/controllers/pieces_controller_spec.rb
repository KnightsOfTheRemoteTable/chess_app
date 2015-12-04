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
      game = create(:game)
      piece_id = game.chess_pieces.find_by(position_x: 1, position_y: 7) # take the queenside black pawn
      get :show, id: piece_id # make sure that piece is selected
      put :update, id: piece_id, { position_x: 1, position_y: 6 } # now move the piece

      expect(response).to be_success
      expect(response).to have_http_status(302) # because we are re-directing to the show page
    end
  end
end
