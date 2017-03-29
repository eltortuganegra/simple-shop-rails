class AddIsAccountEnableFieldToUserTable < ActiveRecord::Migration
  def change
    add_column :users, :is_account_enable, :boolean, :default => true
  end
end
