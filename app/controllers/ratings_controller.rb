class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
    @recent_ratings = Rating.recent
    @top_beers = Rating.all.group_by(&:beer).sort_by{ |beer, _ratings| -beer.average_rating }.take(3)
    @top_breweries = Rating.all.group_by{ |rating| rating.beer.brewery }.sort_by{ |brewery, _ratings| -brewery.average_rating }.take(3)
    @top_styles = Rating.all.group_by{ |rating| rating.beer.style }.sort_by{ |style, _ratings| -style.average_rating }.take(3)
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete
    redirect_to ratings_path
  end
end
