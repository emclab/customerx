#encoding: utf-8
require_dependency "customerx/application_controller"

module Customerx
  class CustomersController < ApplicationController
    #right - customerx_customers
    #index, index_zone, index_individual
    #create
    #update, update_zone, update_individual, activate
    #show, show_zone, show_individual
    #search, search_zone, search_individual
    
        
    #before_filter :require_signin
    before_filter :require_employee

    helper_method :return_last_contact_date
    
    def index
      @title = 'Customers'
      @customers = params[:customerx_customers][:model_ar_r].page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('customer_index_view', 'customerx')
      
    end

    def new
      @title = 'New Customer'
      @customer = Customerx::Customer.new
      @customer.build_address
      @customer.contacts.build
      @erb_code = find_config_const('customer_new_view', 'customerx')
    end

    def create
      #if has_action_right?('create', 'customerx_customers')
      @customer = Customerx::Customer.new(params[:customer], :as => :role_new)
      @customer.last_updated_by_id = session[:user_id]
      if @customer.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @erb_code = find_config_const('customer_new_view', 'customerx')
        render 'new'
      end
      
    end

    def edit
      @title = 'Edit Customer'
      @customer = Customerx::Customer.find(params[:id])
      @erb_code = find_config_const('customer_edit_view', 'customerx')
    end

    def update
      @customer = Customerx::Customer.find(params[:id])
      @customer.last_updated_by_id = session[:user_id]
      if @customer.update_attributes(params[:customer], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @erb_code = find_config_const('customer_edit_view', 'customerx')
        render 'edit'
      end
     
    end

    def show
      @title = 'Customer Info'
      @customer = Customerx::Customer.find(params[:id])
      @erb_code = find_config_const('customer_show_view', 'customerx')
     
    end
    
    def autocomplete
      @customers = Customerx::Customer.where("active = ?", true).order(:name).where("name like ?", "%#{params[:term]}%")
      render json: @customers.map(&:name)    
    end  
    
    protected
    
    def return_last_contact_date(customer_id)
      log = Customerx::CustomerCommRecord.where("customer_id = ?", customer_id).order("created_at DESC").first
      return log.created_at unless log.nil?
    end
    
  end
end
