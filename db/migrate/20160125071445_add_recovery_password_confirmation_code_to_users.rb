class AddRecoveryPasswordConfirmationCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :recovery_password_confirmation_code, :string, :default => nil
  end
end
