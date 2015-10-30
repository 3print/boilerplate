class CreateNewsItems < ActiveRecord::Migration
  def change
    create_table :news_items do |t|
      t.string :title
      t.text :description
      t.date :date
      t.string :origin

      t.timestamps
    end
  end
end
