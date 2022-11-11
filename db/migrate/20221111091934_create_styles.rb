class CreateStyles < ActiveRecord::Migration[7.0]
  def change
    create_table :styles do |t|
      t.text :name

      t.timestamps
    end
  end
end
