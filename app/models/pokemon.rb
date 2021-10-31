class Pokemon < ApplicationRecord
  belongs_to :user

  has_many :bookings, dependent: :destroy
  has_many :reviews, through: :bookings

  validates :name, :location, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :description, length: { minimum: 25 }
end
