Customerx::Engine.routes.draw do

  resources :misc_definitions
  resources :sales_leads, :only => [:index, :new, :create]
  resources :customer_comm_records, :only => [:index, :new, :create]
  resources :customers do
    resources :sales_leads
    resources :customer_comm_records
    collection do
      get :search
      put :search_results
      get :stats
      put :stats_results 
      get :autocomplete
    end
  end
  
  resources :logs, :only => [:index]  
  resources :sales_leads do
    resources :logs
    collection do
      get :search
      put :search_results      
      get :stats
      put :stats_results
    end      
  end
  resources :customer_comm_records do
    resources :logs
    collection do
      get :search
      put :search_results      
      get :stats
      put :stats_results
    end          
  end  
  
  root :to => 'customers#index'
  
end
