class AddAvatarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
    add_column :users, :avatar_meta, :text
    add_column :users, :avatar_gravity, :integer
  end
end
