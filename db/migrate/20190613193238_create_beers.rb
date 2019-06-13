class CreateBeers < ActiveRecord::Migration[5.2]
  def change
    create_table :beers do |t|
      t.string :name
      t.string :abv
      t.string :ibu
      t.text :description

      t.timestamps
    end
  end
end
