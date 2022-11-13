require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    create_places_and_search [ Place.new( name: "Oljenkorsi", id: 1 ) ]

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple found, render all" do
    create_places_and_search [ Place.new( name: "Oljenkorsi", id: 1 ), Place.new( name: "Oljenkorsi 2", id: 2 ) ]

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Oljenkorsi 2"
  end

  it "if none found, show text No locations in x" do
    create_places_and_search []

    expect(page).to have_content "No locations in kumpula"
  end
end

def create_places_and_search (places)
  allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(places)
  allow(WeatherApi).to receive(:weather_in).with("kumpula").and_return(OpenStruct.new(temperature: 10, weather_icons: [], wind_speed: 13, wind_dir: "N"))

  visit places_path
  fill_in('city', with: 'kumpula')
  click_button "Search"
end

