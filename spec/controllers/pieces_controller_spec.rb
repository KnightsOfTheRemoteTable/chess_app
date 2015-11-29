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
end
