class AddStyleToBeer < ActiveRecord::Migration[5.2]
  def change
    add_column :beers, :style, :string
  end
end
