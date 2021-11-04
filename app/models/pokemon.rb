class Pokemon < ApplicationRecord
  belongs_to :user

  has_many :bookings, dependent: :destroy
  has_many :reviews, through: :bookings
  has_many :kind_pokemons, dependent: :destroy
  has_many :kinds, through: :kind_pokemons
  has_one_attached :photo

  validates :name, :location, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :description, length: { minimum: 25 }
end
