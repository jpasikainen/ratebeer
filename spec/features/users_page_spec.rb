require 'rails_helper'

include Helpers

describe "User" do
  let!(:style) { FactoryBot.create :style }

  before :each do
    @user = FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "has made ratings and can see only theirs" do
      sign_in(username: "Pekka", password: "Foobar1")
  
      brewery = FactoryBot.create :brewery, name: "Koff"
      beer = FactoryBot.create :beer, name: "iso 3", brewery:brewery
      FactoryBot.create(:rating, score: 1, beer: beer, user: @user)
      FactoryBot.create(:rating, score: 2, beer: beer, user: FactoryBot.create(:user, username: "user2", password: "Wasd1", password_confirmation: "Wasd1"))
  
      visit user_path(@user)
      expect(page).to have_content "Has made 1 rating"
      expect(page).to have_content "iso 3 1"
    end

    it "without ratings doesn't have favorite brewery nor style" do
      sign_in(username: "Pekka", password: "Foobar1")
      visit user_path(@user)
      expect(page).not_to have_content "Favorite style"
      expect(page).not_to have_content "Favorite brewery"
    end

    it "with a rating can see their favorite brewery and style" do
      sign_in(username: "Pekka", password: "Foobar1")

      brewery = FactoryBot.create :brewery, name: "Koff"
      beer = FactoryBot.create :beer, name: "iso 3", style: style, brewery:brewery
      FactoryBot.create(:rating, score: 1, beer: beer, user: @user)

      visit user_path(@user)
      expect(page).to have_content "Favorite style is #{beer.style.name}"
      expect(page).to have_content "Favorite brewery is #{brewery.name}"
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end
end
