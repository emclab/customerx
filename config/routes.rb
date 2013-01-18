Customerx::Engine.routes.draw do
 
  resources :customer_status_categories
  resources :quality_systems
  resources :customers 
  
  root :to => 'customers#index'
  
end
