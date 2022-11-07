require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when created, is registered to the brewery" do
    visit new_beer_path
    fill_in('beer[name]', with: 'Karhu')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "has a name length greater than one" do
    visit new_beer_path
    expect{
      click_button "Create Beer"
    }.not_to change{Beer.count}.from(0)
    expect(page).to have_content 'Name is too short (minimum is 1 character)'
  end
end
