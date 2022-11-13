class PlacesController < ApplicationController
  def index
  end

  def show
    if session[:previous_search].nil?
      redirect_to places_path, notice: "Id not stored"
    else
      @place = BeermappingApi.get_place(session[:previous_search], params[:id])
    end
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      @weather = WeatherApi.weather_in(params[:city])

      session[:previous_search] = params[:city]
      render :index, status: 418
    end
  end
end
