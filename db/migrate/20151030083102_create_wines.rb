class CreateWines < ActiveRecord::Migration
  def change
    create_table :wines do |t|
      t.string :name
      t.text :head
      t.text :description
      t.string :tech_sheet

      t.timestamps
    end
  end
end
