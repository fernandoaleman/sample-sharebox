Sharebox::Application.routes.draw do

  resources :assets

  get "home/index"

  devise_for :users

  root :to => "home#index"
  
  match "assets/get/:id" => "assets#get", :as => "download"
end
