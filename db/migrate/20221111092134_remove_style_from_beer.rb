class RemoveStyleFromBeer < ActiveRecord::Migration[7.0]
  def change
    add_column :beers, :style_id, :integer
    Beer.all.each do | beer |
      style = Style.find_by name: beer.style
      if style.nil?
        style = Style.create name: beer.style
      end
      beer.style_id = style.id
      beer.save
    end
    remove_column :beers, :style
  end
end
