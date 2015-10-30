class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.integer :order
      t.string :name
      t.string :wine
      t.string :quantity
      t.text :ingredients
      t.text :description

      t.timestamps
    end
  end
end
