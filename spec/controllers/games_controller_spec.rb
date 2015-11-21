require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'GET games#new' do
    it 'responds successfully with an HTTP 200 status code' do
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
end
