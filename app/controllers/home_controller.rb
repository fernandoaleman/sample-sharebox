class HomeController < ApplicationController

  def index
    if user_signed_in?
      # load current user's folders
      @folders = current_user.folders.order("name asc")
      
      # load current user's files(assets)
      @assets = current_user.assets.order("uploaded_file_file_name asc")
    end
  end

end
