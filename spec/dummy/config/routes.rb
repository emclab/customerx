Rails.application.routes.draw do

  mount Authentify::Engine => "/authentify", :as => :authentify
  mount Customerx::Engine => "/customerx", :as => :customerx
  mount Commonx::Engine => "/commonx"
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
    
end
