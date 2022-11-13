module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    # Guard wasnt working properly so this is what we get...
    count = ratings.count
    if count == 0
      0.0
    else
      1.0 * (ratings.sum :score) / count
    end
  end
end
