class AddSequenceToBpTests < ActiveRecord::Migration[4.2]
  def change
    add_column :bp_tests, :sequence, :integer
  end
end
