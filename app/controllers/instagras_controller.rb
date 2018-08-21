class InstagrasController < ApplicationController

  before_action :id_to_name,only:[:list,:fav]
  before_action :chk_login,only:[:new,:edit,:list,:destroy]
  before_action :find_content,only:[:edit,:update,:destroy,:show]
  def index

  end
  
  def login
    
  end

  def list
    @instagra = Instagra.all.order("updated_at DESC")

    @favorite = Favorite.where(user_id:current_user.id).pluck(:picture_id)
  end

  def new
    @instagra = Instagra.new
  end

  def edit
    if @instagra.user_id != current_user.id
     redirect_to list_instagras_path
    end 
  end
  
  
  def update
    if @instagra.update(instagra_params)
     redirect_to list_instagras_path,notice:"編集しました"
    else
     render 'edit'
    end
  end

  def destroy
    if @instagra.user_id != current_user.id
     redirect_to list_instagras_path
    end 
    @instagra.destroy
    redirect_to list_instagras_path,notice:"削除しました"
  end

  def create
    @instagra = Instagra.new(instagra_params)
    @instagra.user_id = current_user.id

    @confirm_mail = {}
    @confirm_mail = {
      'name'   => current_user.name ,
      'mail'   => current_user.email ,
      'content' => @instagra.content
    }

    if params[:back]
      render 'new'
      return
    end

    if @instagra.save
#     ConfirmMailer.confirm_mail(@confirm_mail).deliver 
     redirect_to list_instagras_path , notice: '書き込みました'
    else
      render 'new'
    end  
  
  end

  def confirm

    if !params[:commit]
      redirect_to new_instagra_path
      return
    end

    @instagra = Instagra.new(instagra_params)
    @instagra.user_id = current_user.id

    render :new if @instagra.invalid?
  end
  
  def show
    @favorite = current_user.favorites.find_by(instagra_id:@instagra.id)
    #Select * From favorites Where user_id = Userから継承されるID? AND clone_id = find_byで指定した値 LIMIT 1(find_byの返り値は一つだから?)
  end

  def fav

    if logged_in?
      @instagra = current_user.favorites_instagras
      @favorite = Favorite.where(user_id:current_user.id).pluck(:instagra_id)     
    else
      redirect_to new_session_path
    end

  end

  private
  
  def find_content
    @instagra = Instagra.find(params[:id])
  end
  
  def instagra_params
    params.require(:instagra).permit(:content,:title,:user_id,:image, :image_cache,:remove_image)
  end
  
  def id_to_name

    users = User.select('name','id','icon')
    @users = {}
    @icons = {}

    users.each do |user|
     @users[user.id] = user.name
     if user.icon.model[:icon]
      @icons[user.id] = user.icon
     end
    end

  end

end
