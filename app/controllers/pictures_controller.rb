class PicturesController < ApplicationController

  before_action :id_to_name,only:[:list,:fav]
  before_action :chk_login,only:[:new,:edit,:list,:destroy]
  before_action :find_content,only:[:edit,:update,:destroy,:show,:favshow,:myshow]
  def index

  end
  
  def login
    
  end

  def list
    @picture = Picture.all.order("updated_at DESC")

    @favorite = Favorite.where(user_id:current_user.id).pluck(:picture_id)
  end

  def new
    @picture = Picture.new
  end

  def edit
    if @picture.user_id != current_user.id
     redirect_to list_pictures_path
    end 
  end
  
  
  def update
    if @picture.update(picture_params)
     redirect_to list_pictures_path,notice:"編集しました"
    else
     render 'edit'
    end
  end

  def destroy
    if @picture.user_id != current_user.id
     redirect_to list_pictures_path
    end 
    @picture.destroy
    redirect_to list_pictures_path,notice:"削除しました"
  end

  def create
    @picture = Picture.new(picture_params)
    @picture.user_id = current_user.id

    @confirm_mail = {}
    @confirm_mail = {
      'name'   => current_user.name ,
      'mail'   => current_user.email ,
      'commnet' => @picture.comment
    }

    if params[:back]
     # @picture.image = nil
      render 'new'
      return
    end

    if @picture.save
#     ConfirmMailer.confirm_mail(@confirm_mail).deliver 
#     img = MiniMagick::Image.open('./public' + @picture.image.thumb.url)
#     create_square_image(img,150)
#     img.write './public' + @picture.image.thumb.url

     redirect_to list_pictures_path , notice: '書き込みました'
    else
      render 'new'
    end  
  
  end

  def confirm

    if !params[:commit]
      redirect_to new_picture_path
      return
    end

    @picture = Picture.new(picture_params)
    @picture.user_id = current_user.id

    render :new if @picture.invalid?
  end
  
  def show
    @favorite = current_user.favorites.find_by(picture_id:@picture.id)
    #Select * From favorites Where user_id = Userから継承されるID? AND clone_id = find_byで指定した値 LIMIT 1(find_byの返り値は一つだから?)
  end

  def mypage
    if logged_in?
      @picture = Picture.all.where(user_id:current_user.id).order("updated_at DESC")
      #@user = User.where(user_id:current_user.id)
      @user = User.find(current_user.id)

    else
      redirect_to new_session_path
    end

  end

  def fav

    if logged_in?
      @picture = current_user.favorites_pictures
      @favorite = Favorite.where(user_id:current_user.id).pluck(:picture_id)     
    else
      redirect_to new_session_path
    end

  end

  private
  
  def find_content
    @picture = Picture.find(params[:id])
  end
  
  def picture_params
    params.require(:picture).permit(:comment,:title,:user_id,:image, :image_cache,:remove_image)
  end
  
  def id_to_name

    users = User.select('name','id')
    @users = {}

    users.each do |user|
     @users[user.id] = user.name
    end

  end

  def create_square_image(magick, size)
    narrow = magick[:width] > magick[:height] ? magick[:height] : magick[:width]
    magick.combine_options do |c|
     c.gravity "center"
     c.crop "#{narrow}x#{narrow}+0+0"
    end
    magick.resize "#{size}x#{size}"
  end

end
