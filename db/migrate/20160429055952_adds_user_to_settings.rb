class AddsUserToSettings < ActiveRecord::Migration
  def change
    add_foreign_key :settings, :users
  end
end
