class FavoritesController < ApplicationController

  def create
    favorite = current_user.favorites.create(picture_id: params[:picture_id]) 
    #redirect_to list_pictures_path,notice:"お気に入りにしました。"
    p params
    p '----'
    redirect_to picture_path(params[:picture_id]),notice:"お気に入りにしました。"
  end
  
  def destroy
    #path = Rails.application.routes.recognize_path(request.referer)
    favorite = current_user.favorites.find_by(picture_id: params[:picture_id]).destroy

    redirect_to picture_path(params[:picture_id]), notice: "お気に入り解除しました"
  end

end
