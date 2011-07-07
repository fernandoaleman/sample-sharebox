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

  def share
    # first, we need to separate the emails with the comma
    email_addresses = params[:email_addresses].split(",")
    
    email_addresses.each do |email_address|
      # save the details in the SharedFolder table
      @shared_folder = current_user.shared_folders.new
      @shared_folder.folder_id = params[:folder_id]
      @shared_folder.shared_email = email_address
      
      # getting the shared user id right, the owner the email has already signed up with Sharebox
      # if not, the field "shared_user_id" will be left nil for now
      shared_user = User.find_by_email(email_address)
      @shared_folder.shared_user_id = shared_user.id if shared_user
      
      @shared_folder.message = params[:message]
      @shared_folder.save
      
      # now we need to send email to the Shared User
    end
    
    # since this action is mainly for ajax, we'll respond with js file back (refer to share.js.erb)
    respond_to do |format|
      format.js {
        
      }
    end
  end
end
