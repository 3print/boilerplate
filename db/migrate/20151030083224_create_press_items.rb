class CreatePressItems < ActiveRecord::Migration
  def change
    create_table :press_items do |t|
      t.string :title
      t.text :description
      t.date :date

      t.timestamps
    end
  end
end
