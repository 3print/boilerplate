class AddAvatarGravityToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :avatar_gravity, :integer
  end
end
