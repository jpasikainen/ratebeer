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


    ratings.group_by{|r| r.beer.style}.map{|style, ratings| next ratings.sum(&:score), style}.sort_by{|score, style| score}.last[1]
    #ratings.group_by{|r| r.beer.style}.sort_by{|style, ratings| ratings.sum(&:score)}.last[0]
    #ratings.select(ratings.group_by{|r| r.beer.style}.each.map{|_beer, ratings| ratings.map{|r| r.score}.sum})
    #styles = ratings.map{|rating| rating.beer.style}.uniq
    #ratings.group_by{|r| r.beer.style}.sort_by{|style, ratings| ratings.sum(&:score)}.first[0]
    #style_rating = 
    #ratings.group_by{|r| r.beer.style}.sort_by{|ratings, _beers| ratings.sum}.last
  end
end
# Beer.all.group_by(&:style).sort_by{|ratings, _beers| ratings.sum}