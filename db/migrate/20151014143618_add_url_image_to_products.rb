class AddUrlImageToProducts < ActiveRecord::Migration
  def change
    add_column :products,
      :image_url,
      :string,
      {
        limit: 256
      }
  end
end
