ChessApp::Application.routes.draw do
  devise_for :users
  root 'static_pages#index'
  resources :pieces, only: [:show, :update]
  resources :games, only: [:new, :create, :show] do
    put 'forfeit', on: :member
  end
end
