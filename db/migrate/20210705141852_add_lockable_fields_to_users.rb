class AddLockableFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :locked_at, :datetime
    add_column :users, :failed_attempts, :integer
    add_column :users, :unlock_token, :string

    add_index :users, :unlock_token, unique: true
  end
end
