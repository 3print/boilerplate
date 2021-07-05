class AddMultipleEnumToBpTests < ActiveRecord::Migration[4.2]
  def change
    add_column :bp_tests, :multiple_enum, :integer, array: true, default: []
  end
end
