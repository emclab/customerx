# encoding: utf-8
require_dependency "customerx/application_controller"

module Customerx
  class CustomerStatusCategoriesController < ApplicationController
    
    before_filter :require_signin
    before_filter :require_employee
    
    helper_method 
    
    def index
      @title = 'Customer Status Category'
      if has_create_right?('customerx_customer_status_categories') || has_update_right?('customerx_customer_status_categories')
        @customer_status_categories = Customerx::CustomerStatusCategory.order("ranking_order")
      else
        @customer_status_categories = Customerx::CustomerStatusCategory.where('active = ?', true).order("ranking_order")
      end
    end

    def new
      @title = 'New Customer Status Category'
      if has_create_right?('customerx_customer_status_categories')
        @customer_status_category = Customerx::CustomerStatusCategory.new()
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
    
    def create
      if has_create_right?('customerx_customer_status_categories')
        @customer_status_category = Customerx::CustomerStatusCategory.new(params[:customer_status_category], :as => :role_new)
        @customer_status_category.last_updated_by_id = session[:user_id]
        if @customer_status_category.save
          redirect_to customer_status_categories_path, :notice => "Customer Status Category Saved!"
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'new'
        end
      end
    end
    
    def edit
      @title = 'Edit Customer Status Category'
      if has_update_right?('customerx_customer_status_categories')
        @customer_status_category = Customerx::CustomerStatusCategory.find(params[:id])
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
  
    def update
      if has_update_right?('customerx_customer_status_categories')
        @customer_status_category = Customerx::CustomerStatusCategory.find(params[:id])
        @customer_status_category.last_updated_by_id = session[:user_id]
        if @customer_status_category.update_attributes(params[:customer_status_category], :as => :role_update)
          redirect_to customer_status_categories_path, :notice => "Customer Status Category Updated!"
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'edit'
        end
      end      
    end

    protected
    

  end
end
