ChessApp::Application.routes.draw do
  devise_for :users
  root 'static_pages#index'
  resource :games, only: [:new, :create, :show]
end
