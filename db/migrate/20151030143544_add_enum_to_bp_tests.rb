class AddEnumToBpTests < ActiveRecord::Migration
  def change
    add_column :bp_tests, :enum, :string
  end
end
