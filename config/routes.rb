Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :pokemons, only: [:index, :show, :new, :create, :edit] do
    resources :kind_pokemons, only: [:create]
    resources :bookings, only: [:new, :create]
  end
  resources :bookings, only: [:destroy, :update, :show]
  resource :dashboard, only: [:show]
end
