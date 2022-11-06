class User < ApplicationRecord
  include RatingAverage
  has_secure_password

  has_many :memberships
  has_many :ratings
  has_many :beers, through: :ratings
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :password, presence: true, format: { with: /\A(?=.*[a-zA-Z])(?=.*[A-Z])(?=.*[0-9]).{4,}\z/ }
end
