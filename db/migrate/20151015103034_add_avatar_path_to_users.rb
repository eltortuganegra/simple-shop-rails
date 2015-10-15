class AddAvatarPathToUsers < ActiveRecord::Migration
  def change
    add_column :users,
      :avatar_path,
      :string, {
        limit: 256,
        null: true,
        default: nil
      }
  end
end
