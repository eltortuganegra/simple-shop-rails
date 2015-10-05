class AddConfirmationCodeToUsers < ActiveRecord::Migration
  CONFIRMATION_CODE_DEFAULT_VOID_VALUE = ''

  def change
    add_column :users, :confirmation_code, :string, :default => CONFIRMATION_CODE_DEFAULT_VOID_VALUE
    add_index :users, :confirmation_code
  end
end
