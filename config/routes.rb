Customerx::Engine.routes.draw do

  resources :customer_status_categories
  resources :comm_categories
  resources :quality_systems
  resources :lead_sources
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
  
  resources :lead_logs, :only => [:index]  
  resources :comm_record_logs, :only => [:index]
  resources :sales_leads do
    resources :lead_logs
    collection do
      get :search
      put :search_results      
      get :stats
      put :stats_results
    end      
  end
  resources :customer_comm_records do
    resources :comm_record_logs
    collection do
      get :search
      put :search_results      
      get :stats
      put :stats_results
    end          
  end  
  
  root :to => 'customers#index'
  
end
