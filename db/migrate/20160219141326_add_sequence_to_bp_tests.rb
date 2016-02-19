class AddSequenceToBpTests < ActiveRecord::Migration
  def change
    add_column :bp_tests, :sequence, :integer
  end
end
