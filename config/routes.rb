ChessApp::Application.routes.draw do
  devise_for :users
  root 'static_pages#index'
  resources :pieces, only: [:show, :update] do
    get 'valid_moves', on: :member
  end
  resources :games, only: [:index, :new, :create, :show] do
    put 'forfeit', on: :member
    put 'join', on: :member
  end
end
