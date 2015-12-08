class AddApprovedAndValidatedOnBpTests < ActiveRecord::Migration
  def change
    add_column :bp_tests, :approved_at, :datetime
    add_column :bp_tests, :validated_at, :datetime
  end
end
