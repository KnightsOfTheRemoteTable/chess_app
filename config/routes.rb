ChessApp::Application.routes.draw do
  root 'static_pages#index'
  resource :games, :only => [:new, :create, :show]
end
