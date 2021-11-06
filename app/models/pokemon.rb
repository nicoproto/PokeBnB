class Pokemon < ApplicationRecord
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  belongs_to :user

  has_many :bookings, dependent: :destroy
  has_many :reviews, through: :bookings
  has_many :kind_pokemons, dependent: :destroy
  has_many :kinds, through: :kind_pokemons
  has_one_attached :photo

  validates :name, :location, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :description, length: { minimum: 25 }

  include PgSearch::Model
  pg_search_scope :global_search,
    against: [ :name, :description ],
    associated_against: {
      kinds: [ :name ]
    },
    using: {
      tsearch: { prefix: true }
    }
end
