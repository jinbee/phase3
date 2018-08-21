module PicturesHelper
    def new_or_edit
      if action_name == 'new' || action_name == 'confirm' || action_name == 'create'
        confirm_pictures_path
      elsif action_name == 'edit'
        picture_path
      end
    end 
  

end
