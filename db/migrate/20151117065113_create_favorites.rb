class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.string :user_name
      t.string :user_email

      t.timestamps
    end
  end
end
