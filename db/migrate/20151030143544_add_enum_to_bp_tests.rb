class AddEnumToBpTests < ActiveRecord::Migration[4.2]
  def change
    add_column :bp_tests, :enum, :string
  end
end
