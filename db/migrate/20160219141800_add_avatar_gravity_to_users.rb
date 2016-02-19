class AddAvatarGravityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_gravity, :integer
  end
end
