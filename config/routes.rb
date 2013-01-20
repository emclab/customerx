Customerx::Engine.routes.draw do

  resources :customer_status_categories
  resources :quality_systems
  resources :customers do
    resources :sales_leads
  end
  resources :sales_leads, :only => [:index]
  resources :sales_leads do
    resources :lead_logs
  end
 
  
  root :to => 'customers#index'
  
end
