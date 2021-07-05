class AddApprovedAndValidatedOnBpTests < ActiveRecord::Migration[4.2]
  def change
    add_column :bp_tests, :approved_at, :datetime
    add_column :bp_tests, :validated_at, :datetime
  end
end
