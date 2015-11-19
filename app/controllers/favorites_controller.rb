class FavoritesController < ApplicationController

  def create
    @favorite = Favorite.new()
    @favorite.favorited_id = params[:id]
    @favorite.favoriter_id = current_user.id
    
    @favorite.save!
  end

  def destroy
    @favorite = Favorite.where(favoriter_id: current_user.id, favorited_id: params[:id]).take(1)
    @favorite.destroy
  end
end
