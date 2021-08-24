class ChangeUserAvatarGravityToRegions < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :avatar_gravity
    add_column :users, :avatar_regions, :json
  end
end
