Rails.application.routes.draw do

  root "users#index"

  resources :locations, only: [:index, :show] do
    resources :comments, only: [:new, :create, :destroy]
  end

  get '/nearby', to: 'locations#generate_shelters', as: :nearby_shelters

  resources :users, except: [:destroy] do
    resources :comments, only: [:new, :create, :destroy]
  end

  get '/about', to: 'abouts#index', as: :index

  resources :comments do
    resources :comments, only: [:new, :create, :destroy]
  end

  resources :sessions, only: [:create]

  get    '/login',  to: 'sessions#new'

  delete '/logout', to: 'sessions#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
