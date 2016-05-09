class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.belongs_to :user, {required: true}
      t.string :confirmation_code
      t.timestamps null: false
    end
  end
end
