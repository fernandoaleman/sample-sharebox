class HomeController < ApplicationController

  def index
    if user_signed_in?
      # show only root folders (which have no parent folders)
      @folders = current_user.folders.roots
      
      # show only root files which have no "folder_id"
      @assets = current_user.assets.where("folder_id is NULL").order("uploaded_file_file_name asc")
    end
  end
  
  def browse
    @current_folder = current_user.folders.find(params[:folder_id])
    
    if @current_folder
      # getting the folders which are inside thie @current_folder
      @folders = @current_folder.children
      
      # show only files under this current folder
      @assets = @current_folder.assets.order("uploaded_file_file_name asc")
      
      render :action => "index"
    else
      flash[:error] = "Don't be cheeky! Mind your own folders!"
      redirect_to root_url
    end
  end

end
