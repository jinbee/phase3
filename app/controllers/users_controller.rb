class UsersController < ApplicationController
  def index
    @user = User.all
  end
  
  def new
   @user = User.new
  end 

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path ,notice: 'ユーザーを追加しました'
    else
      render 'new' 
    end
  end

  def edit
    @user = User.find(params[:id])
    p '----'
    p @user
  end


  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
     redirect_to users_path , notice:"編集しました"
    else
     render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path,notice: 'ユーザーを削除しました'
  end

  
  private
  def user_params
   params.require(:user).permit(:name,:email,:password,:password_confirmation,:user_id)
  end

end
