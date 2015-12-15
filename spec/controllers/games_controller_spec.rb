require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'GET games#index' do
    it 'responds successfully with an HTTP 200 status code' do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET games#index' do
    it 'assigns the correct variable' do
      get :index

      expect(assigns(:games)).not_to be_nil
    end
  end

  describe 'GET games#index' do
    it 'renders the correct template' do
      get :index

      expect(response).to render_template(:index)
    end
  end

  describe 'GET games#new' do
    it 'responds successfully with an HTTP 200 status code' do
      sign_in create(:user)
      get :new

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET games#new' do
    it 'assigns the correct variable' do
      sign_in create(:user)
      get :new

      expect(assigns(:game)).not_to be_nil
    end
  end

  describe 'GET games#new' do
    it 'renders the correct template' do
      sign_in create(:user)
      get :new

      expect(response).to render_template(:new)
    end
  end

  describe 'POST games#create' do
    it 'successfully redirects the user' do
      sign_in create(:user)
      post :create, game: attributes_for(:game)

      expect(response).to redirect_to games_path
    end

    it 'sets the user to the black player' do
      sign_in create(:user)
      game = attributes_for(:game)
      post :create, game: game

      expect(flash[:notice]).to eq 'Game created. You are the black player.'
    end
  end

  describe 'GET games#show' do
    it 'responds successfully with an HTTP 200 status code' do
      game = create(:game)
      get :show, id: game

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'assigns the correct instance variables to the templates' do
      game = create(:game)
      get :show, id: game

      expect(assigns(:game)).not_to be_nil
    end

    it 'renders the correct template' do
      game = create(:game)
      get :show, id: game

      expect(response).to render_template('show')
    end

    it 'flashes that the game is in check if the game is in check' do
      game = create(:game)
      allow_any_instance_of(Game).to receive(:check?).and_return(true)
      get :show, id: game

      expect(flash[:alert]).to eq 'The game is in a state of check'
    end
  end

  describe 'PUT games#forfeit' do
    it 'sets the opposite player as the winner' do
      black_player = create(:user)
      white_player = create(:user)
      game = create(:game, black_player: black_player, white_player: white_player)
      sign_in black_player

      put :forfeit, id: game

      expect(response).to redirect_to games_path
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

  describe 'PUT games#join' do
    it 'assigns the joining player to be the white player' do
      game = Game.create(name: 'TEST GAME', black_player: build(:user), white_player: nil)
      white_player = create(:user)
      sign_in white_player
      put :join, id: game

      expect(game.reload.white_player).to eq white_player
    end

    it 'upon success, redirects a user to the game' do
      game = Game.create(name: 'TEST GAME', black_player: build(:user), white_player: nil)
      white_player = create(:user)
      sign_in white_player
      put :join, id: game

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(game_path(game))
    end

    it 'redirects a user to the login if the user is not signed in' do
      game = create(:game, black_player: build(:user), white_player: nil)
      create(:user)
      put :join, id: game

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns a status of unauthorized if the game is full' do
      game = create(:game)
      white_player = create(:user)
      sign_in white_player
      put :join, id: game

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a status of unauthorized if the same player tries to play both colors' do
      black_player = create(:user)
      game = create(:game, black_player: black_player)
      sign_in black_player
      put :join, id: game

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
