Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :pokemons, only: [:index, :show, :new, :create] do
    resources :kind_pokemons, only: [:create]
  end
end
