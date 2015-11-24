require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  describe 'GET pieces#show' do
    it 'responds successfully with an HTTP 200 status code' do
      game = FactoryGirl.create(:game)
      get :show, id: game

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end
end
