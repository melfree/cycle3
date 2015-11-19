class AddFavoritedIdToFavorites < ActiveRecord::Migration
  def change
    add_column :favorites, :favorited_id, :integer
  end
end
