require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "are all shown on ratings page" do
    FactoryBot.create(:rating, score: 10, user: user)
    FactoryBot.create(:rating, score: 20, user: user)
    visit ratings_path

    user.ratings.each do |r|
      expect(page).to have_content "#{r.beer.name} #{r.score} #{r.updated_at}"
    end
  end

  it "can be removed from GUI" do
    r = FactoryBot.create(:rating, user: user)
    visit user_path(user)
    expect{
      click_link("delete", href: "/ratings/#{r.id}")
    }.to change{Rating.count}.from(1).to(0)
  end
end
