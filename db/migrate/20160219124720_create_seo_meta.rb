class CreateSeoMeta < ActiveRecord::Migration
  def change
    create_table :seo_meta do |t|
      t.integer :meta_owner_id
      t.string :meta_owner_type
      t.string :title
      t.text :description
      t.string :static_action
      t.boolean :static_mode

      t.timestamps
    end

    add_index :seo_meta, [:meta_owner_id, :meta_owner_type]
  end
end
