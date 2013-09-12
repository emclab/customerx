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
      @erb_code = find_config_const('customer_create_view', 'customerx')
    end

    def create
      #if has_action_right?('create', 'customerx_customers')
      @customer = Customerx::Customer.new(params[:customer], :as => :role_new)
      @customer.last_updated_by_id = session[:user_id]
      if @customer.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
      
    end

    def edit
      @title = 'Edit Customer'
      @customer = Customerx::Customer.find(params[:id])
      @erb_code = find_config_const('customer_update_view', 'customerx')
    end

    def update
      @customer = Customerx::Customer.find(params[:id])
      @customer.last_updated_by_id = session[:user_id]
      if @customer.update_attributes(params[:customer], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
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
    
    def search
      #here are search right:
      #search_individual - only for customers who belongs to individual sales
      #search_zone - allow to search customer which belongs to a zone
      #search - allow to search all customers
      #if has_action_right?('search', 'customerx_customers') || 
      #   has_action_right?('search_zone', 'customerx_customers') ||
       #  has_action_right?('search_individual', 'customerx_customers') 
      @customer = Customerx::Customer.new()
      #else
      #  redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      #end
    end

    def search_results
      @customer = Customerx::Customer.new(params[:customer], :as => :role_search_stats)
      @customers = @customer.find_customers()
      #if has_action_right?('search', 'customerx_customers') || 
       #  has_action_right?('search_zone', 'customerx_customers') ||
       #  has_action_right?('search_individual', 'customerx_customers') 
      @customers = sort_customers(@customers)
        #seach params
      @search_params = search_params()
      #else
      #  redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      #end
    end
    
    protected
    
    def search_params
      search_params = "参数："
      search_params += ' 开始日期：' + params[:customer][:start_date_s] if params[:customer][:start_date_s].present?
      search_params += ', 结束日期：' + params[:customer][:end_date_s] if params[:customer][:end_date_s].present?
      search_params += ', 关键词 ：' + params[:customer][:keyword] if params[:customer][:keyword].present?
      search_params += ', 片区 ：' + Authentify::Zone.find_by_id(params[:customer][:zone_id_s].to_i).zone_name if params[:customer][:zone_id_s].present?
      search_params += ', 业务员 ：' + Authentify::User.find_by_id(params[:customer][:sales_id_s].to_i).name if params[:customer][:sales_id_s].present?
      search_params += ', 客户 状态：' + Customerx::MiscDefinition.where(:for_which => 'customer_status').find_by_id(params[:customer][:status_category_s].to_i).cate_name if params[:customer][:status_category_s].present?
      search_params
    end
    
    def return_last_contact_date(customer_id)
      log = Customerx::CustomerCommRecord.where("customer_id = ?", customer_id).order("created_at DESC").first
      return log.created_at unless log.nil?
    end
    
  end
end
