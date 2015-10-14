class AddDisableAtToProducts < ActiveRecord::Migration
  def change
    add_column :products, :disabled_at, :datetime, :default => nil    
  end
end
