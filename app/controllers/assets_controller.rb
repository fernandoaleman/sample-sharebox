class AssetsController < ApplicationController

  before_filter :authenticate_user!
  
  def index
    @assets = current_user.assets
  end

  def new
    @asset = current_user.assets.new
  end

  def create
    @asset = current_user.assets.new(params[:asset])
    if @asset.save
      redirect_to root_url, :notice => "Successfully created asset."
    else
      render :action => 'new'
    end
  end

  def update
    @asset = current_user.assets.find(params[:id])
    if @asset.update_attributes(params[:asset])
      redirect_to @asset, :notice  => "Successfully updated asset."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @asset = current_user.assets.find(params[:id])
    @asset.destroy
    redirect_to assets_url, :notice => "Successfully destroyed asset."
  end
  
  def get
    asset = current_user.assets.find_by_id(params[:id])
    if asset
      # Parse the URL for special characters first before downloading
      data = open(URI.parse(URI.encode(asset.uploaded_file.url)))
      
      # then again, use the "send_data" method to send the above binary "data" as file
      send_data data, :filename => asset.file_name
      
      # redirect to amazon S3 url which will let the user download the file automatically
      # redirect_to asset.uploaded_file.url, :type => asset.uploaded_file_content_type
    else
      flash[:error] = "Don't be cheeky! Mind your own assets!"
      redirect_to assets_path
    end
  end
end
