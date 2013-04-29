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

    helper_method :has_comm_record_index_right?, :has_lead_index_right?, :return_last_contact_date, :has_action_on_customer?
    
    def index
      @title = 'Customers'
      @customers = params[:customerx_customers][:model_ar_r].page(params[:page]).per_page(@max_pagination)
      #has_right = true
      #params[:customer] = {}  #instanciate the params object
      #if grant_access?('index', 'customerx_customers')
     #   params[:customer] = {} 
     # elsif grant_access?('index_zone', 'customerx_customers')
     #   params[:customer][:zone_id_s] = session[:user_privilege].user_zone_ids         
     # elsif grant_access?('index_individual', 'customerx_customers')
      #  params[:customer][:sales_id_s] = session[:user_id]
     # else
     #   has_right = false
     #   redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")    
     # end
      #return @customers if has right     
     # if has_right
     #   customer = Customerx::Customer.new(params[:customer], :as => :role_search_stats)
     #   @customers = sort_by_activate_right(customer)
     # end
    end

    def new
      @title = 'New Customer'
      @customer = Customerx::Customer.new
      @customer.build_address
      @customer.contacts.build
      #unless has_action_right?('create', 'customerx_customers')
      #  redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      #end
    end

    def create
      #if has_action_right?('create', 'customerx_customers')
        @customer = Customerx::Customer.new(params[:customer], :as => :role_new)
        @customer.last_updated_by_id = session[:user_id]
        if @customer.save
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Customer Saved!")
        else
          flash[:notice] = 'Data error. NOT Saved!'
          render 'new'
        end
      #else
      # redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      #end
    end

    def edit
      @title = 'Edit Customer'
      @customer = Customerx::Customer.find(params[:id])
      #if !has_action_right?('update', 'customerx_customers', @customer)
      #  redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      #end
    end

    def update
      @customer = Customerx::Customer.find(params[:id])
     # if has_action_right?('update', 'customerx_customers', @customer)       
        @customer.last_updated_by_id = session[:user_id]
        if @customer.update_attributes(params[:customer], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Customer Update Saved!")
        else
          flash[:notice] = 'Data error. NOT Saved!'
          render 'edit'
        end
     # else  # else needed. Otherwise having Missing Template IF false.
     #   redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      #end
    end

    def show
      @title = 'Customer Info'
      @customer = Customerx::Customer.find(params[:id])
     # if !has_action_right?('show', 'customerx_customers', @customer)
     #   redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
     # end
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
    
    #sort customer based on search right
    #def sort_customers(customers)
    ##    customers
     # elsif grant_access?('search_zone', 'customerx_customers')
     #   user_zone_ids = session[:user_priviledge].user_zones
     #   customers = customers.where(:customer => {:zone_id => user_zone_ids})
     # elsif grant_access?('search_individual', 'customerx_customers') 
     #   customers = customers.where("customerx_customers.sales_id = ?", session[:user_id])
     # else
     #   customers = []
     # end
     # customers.page(params[:page]).per_page(30)
    #end
    
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
    
    #def sort_by_activate_right(customer)
    #  customers = customer.find_customers.page(params[:page]).per_page(30).order("active DESC, zone_id, id DESC, since_date DESC")
    #  return customers if customers.blank?   #customers.blank? return true and customers.nil? return false for empty customers
    #  if !grant_access?('activate', 'customerx_customers')
    #    customers = customers.where(:active => true)
    #  end
      #customers = customers.order("active DESC, zone_id, id DESC, since_date DESC").page(params[:page]).per_page(30)
    #  customers
    #end

    def return_last_contact_date(customer_id)
      log = Customerx::CustomerCommRecord.where("customer_id = ?", customer_id).order("created_at DESC").first
      return log.created_at unless log.nil?
    end
    
  end
end
