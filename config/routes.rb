ChessApp::Application.routes.draw do
  root 'static_pages#index'
  rescourse :games , :only [:new, :create, :show]
end
