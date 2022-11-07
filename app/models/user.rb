class User < ApplicationRecord
  include RatingAverage
  has_secure_password

  has_many :memberships, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :password, presence: true, format: { with: /\A(?=.*[a-zA-Z])(?=.*[A-Z])(?=.*[0-9]).{4,}\z/ }

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    ratings.group_by{ |r| r.beer.style }.map{ |style, ratings| next ratings.sum(&:score), style }.max_by{ |score, _style| score }[1]
  end

  def favorite_brewery
    return nil if ratings.empty?

    ratings.group_by{ |r| r.beer.brewery }.map{ |brewery, ratings| next ratings.sum(&:score), brewery }.max_by{ |score, _brewery| score }[1]
  end
end
