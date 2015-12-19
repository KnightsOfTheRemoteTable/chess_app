ChessApp::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'static_pages#index'
  resources :pieces, only: [:show, :update] do
    member do
      get 'valid_moves'
      put 'promote'
    end
  end
  resources :users, only: [:show, :update] do
    get '/username', to: 'users#username'
  end
  resources :games, only: [:index, :new, :create, :show] do
    put 'forfeit', on: :member
    put 'join', on: :member
  end
end
