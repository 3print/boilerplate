class AddMultipleEnumToBpTests < ActiveRecord::Migration
  def change
    add_column :bp_tests, :multiple_enum, :integer, array: true, default: []
  end
end
