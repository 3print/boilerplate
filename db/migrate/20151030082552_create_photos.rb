class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :owner_type
      t.integer :owner_id
      t.string :file
      t.string :kind

      t.timestamps
    end

    add_index :photos, [:owner_type, :owner_id]
    add_index :photos, [:kind]
  end
end
