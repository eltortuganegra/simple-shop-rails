class ChangeConfirmationCodeToUsersTable < ActiveRecord::Migration
  def change
    change_column :users,
        :confirmation_code,
        :string,
        {
            :limit => 36,
            :null => true,
            :default => nil,
            :index => true
        }
  end
end
