class AddFavoriterIdToFavorites < ActiveRecord::Migration
  def change
  	add_column :favorites, :favoriter_id, :integer
  end
end
