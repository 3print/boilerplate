class AddImageFieldsToBpTests < ActiveRecord::Migration[5.2]
  def change
    add_column :bp_tests, :image_gravity, :integer
    add_column :bp_tests, :image_alt_text, :string

    add_column :bp_tests, :visual, :string
    add_column :bp_tests, :visual_regions, :json
  end
end
