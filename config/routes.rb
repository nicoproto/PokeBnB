Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :pokemons, only: [:index, :show, :new, :create]
end
