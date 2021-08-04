class RemoveAvatarMetaFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :avatar_meta
  end
end
