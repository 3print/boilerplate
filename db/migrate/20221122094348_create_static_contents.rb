class CreateStaticContents < ActiveRecord::Migration[7.0]
  def change
    create_table :static_contents do |t|
      t.string :name
      t.string :key
      t.string :content

      t.timestamps
    end
  end
end
