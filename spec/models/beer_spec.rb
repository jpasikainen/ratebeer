require 'rails_helper'

RSpec.describe Beer, type: :model do
  describe "creation" do
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }

    it "succeeds with name, style and brewery" do
      beer = Beer.create name: "beer", style: Style.create(name: "name"), brewery: test_brewery
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end

    it "fails without a name" do
      beer = Beer.create style: Style.create(name: "name"), brewery: test_brewery
      expect(beer).to_not be_valid
    end

    it "fails without a style" do
      beer = Beer.create name: "beer", brewery: test_brewery
      expect(beer).to_not be_valid
    end
  end
end
