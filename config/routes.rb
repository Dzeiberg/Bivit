RsgLinkedinGem::Application.routes.draw do
  resources :notifications


  require 'faye'
  Faye::WebSocket.load_adapter('thin')
  # mount Faye::RackAdapter.new(:timeout => 25), at: '/faye'
  mount Faye::RackAdapter.new(:mount => '/faye', :timeout => 25) => '/mad_chatter'
  devise_for :users
  resources :linkedin
  match '/linkedin_profile' => "linkedin#linkedin_profile"
  match '/oauth_account' => "linkedin#oauth_account"
  match '/linkedin_oauth_url' => 'linkedin#generate_linkedin_oauth_url'

resources :rooms do
    resources :messages
  end

 root to: "static_pages#home"

  resources :users do
    member do
      get :following, :followers
    end
  end

  match '/home', to: "static_pages#home"

  match '/index', to: "linkedin#index"
	
  get '/auth/:provider/callback', to: 'sessions#create'

  match '/help', to: "static_pages#help"

  match '/room', to: "rooms#index"

  match '/about', to: "static_pages#about"

  match '/contact', to: "static_pages#contact"

  resources :articles do
    resources :comments
  end
  
  resources :users do
    resources :comments
  end

  resources :users do
    resources :messages
  end

  resources :users do
    resources :rooms
  end


  resources :rooms

  resources :messages

  resources :comments

  resources :articles, only: [:create, :destroy, :show, :index]
  
  resources :sessions, only: [:new, :create, :destroy]

  resources :relationships, only: [:create, :destroy]
end
