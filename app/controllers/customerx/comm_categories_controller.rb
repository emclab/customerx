require_dependency "customerx/application_controller"

module Customerx
  class CommCategoriesController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee
    
    helper_method 
    
    def index
      @title = 'Customer Communication Category'
      if has_create_right?('customerx_comm_categories') || has_update_right?('customerx_comm_categories')
        @comm_categories = Customerx::CommCategory.order("ranking_order")
      else
        @comm_categories = Customerx::CommCategory.where('active = ?', true).order("ranking_order")
      end
    end

    def new
      @title = 'New Customer Communication Category'
      if has_create_right?('customerx_comm_categories')
        @comm_category = Customerx::CommCategory.new()
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
    
    def create
      if has_create_right?('customerx_comm_categories')
        @comm_category = Customerx::CommCategory.new(params[:comm_category], :as => :role_new)
        @comm_category.last_updated_by_id = session[:user_id]
        if @comm_category.save
          redirect_to comm_categories_path, :notice => "Customer Communication Category Saved!"
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'new'
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end
    end
    
    def edit
      @title = 'Update Qualty System'
      if has_update_right?('customerx_comm_categories')
        @comm_category = Customerx::CommCategory.find(params[:id])
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
  
    def update
      if has_update_right?('customerx_comm_categories')
        @comm_category = Customerx::CommCategory.find(params[:id])
        @comm_category.last_updated_by_id = session[:user_id]
        if @comm_category.update_attributes(params[:comm_category], :as => :role_update)
          redirect_to comm_categories_path, :notice => "Customer Communication Category Updated!"
        else
          flash.now[:error] = 'Data Error. Not Updated!'
          render 'edit'
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end      
    end

    protected
    
  end
end
