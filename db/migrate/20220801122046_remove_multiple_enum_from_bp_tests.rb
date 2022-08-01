class RemoveMultipleEnumFromBpTests < ActiveRecord::Migration[7.0]
  def change
    remove_column :bp_tests, :multiple_enum, :integer
  end
end
