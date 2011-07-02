class FoldersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @folders = current_user.folders
  end

  def show
    @folder = current_user.folders.find(params[:id])
  end

  def new
    @folder = current_user.folders.new
    
    # if there is "folder_id" param, we know that we are under a folder
    # thus, we will essentially create a subfolder
    if params[:folder_id]
      # we still need to set the @current_folder to make the buttons work
      @current_folder = current_user.folders.find(params[:folder_id])
      
      # then we make sure the folder we are creating has a parent folder
      # which is the @current_folder
      @folder.parent_id = @current_folder.id
    end
  end

  def create
    @folder = current_user.folders.new(params[:folder])
    if @folder.save
      flash[:notice] = "Successfully created folder"
      
      if @folder.parent
        redirect_to browse_path(@folder.parent)
      else
        redirect_to root_url
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @folder = current_user.folders.find(params[:id])
  end

  def update
    @folder = current_user.folders.find(params[:id])
    if @folder.update_attributes(params[:folder])
      redirect_to @folder, :notice  => "Successfully updated folder."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @folder = current_user.folders.find(params[:id])
    @folder.destroy
    redirect_to folders_url, :notice => "Successfully destroyed folder."
  end
end
