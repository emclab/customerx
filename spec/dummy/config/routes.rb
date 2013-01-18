Rails.application.routes.draw do

  get "user_menus/index"
  get "quality_systems/index"

  mount Authentify::Engine => "/authentify/", :as => :authentify
  mount Customerx::Engine => "/customerx", :as => :customerx
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
    
end
