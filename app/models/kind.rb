class Kind < ApplicationRecord
  has_many :kind_pokemons, dependent: :destroy
end
