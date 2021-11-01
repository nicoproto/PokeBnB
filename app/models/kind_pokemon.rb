class KindPokemon < ApplicationRecord
  belongs_to :pokemon
  belongs_to :kind

  validates :pokemon, uniqueness: { scope: :kind}
end
