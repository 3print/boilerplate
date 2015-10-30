class CreatePortraits < ActiveRecord::Migration
  def change
    create_table :portraits do |t|
      t.string :name
      t.string :function
      t.text :description
      t.integer :order

      t.timestamps
    end
  end
end
