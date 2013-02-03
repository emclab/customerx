#encoding: utf-8
require_dependency "customerx/application_controller"

module Customerx
  class CustomersController < ApplicationController
        
    before_filter :require_signin
    before_filter :require_employee

    helper_method :has_comm_log_right?, :has_lead_right? #, :return_last_contact_date
    
    def index
      @title = 'Customers'
      if has_index_right?('customerx_customers')
        if has_activate_right?('customerx_customers')
          @customers = Customerx::Customer.page(params[:page]).per_page(30).order("active DESC, zone_id, id DESC, since_date DESC")
        else
          @customers = Customerx::Customer.active_cust.order("zone_id, id DESC, since_date DESC").page(params[:page]).per_page(30) #.paginate(:per_page => 30, :page => params[:page])
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")    
      end
    end

    def new
      @title = 'New Customer'
      @customer = Customerx::Customer.new
      if !has_create_right?('customerx_customers')
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end

    def create
      if has_create_right?('customerx_customers')
        @customer = Customerx::Customer.new(params[:customer], :as => :role_new)
        @customer.last_updated_by_id = session[:user_id]
        if @customer.save
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Customer Saved!")
        else
          flash[:notice] = 'Data error. NOT Saved!'
          render 'new'
        end
      end
    end

    def edit
      @title = 'Edit Customer'
      @customer = Customerx::Customer.find(params[:id])
      if !has_update_right?('customerx_customers')
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end

    def update
      if has_update_right?('customerx_customers')
        @customer = Customerx::Customer.find(params[:id])
        @customer.last_updated_by_id = session[:user_id]
        if @customer.update_attributes(params[:customer], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Customer Update Saved!")
        else
          flash[:notice] = 'Data error. NOT Saved!'
          render 'edit'
        end
      end
    end

    def show
      @title = 'Customer Info'
      @customer = Customerx::Customer.find(params[:id])
      if !has_show_right?('customerx_customers')
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
    
    def autocomplete
      @customers = Customerx::Customer.where("active = ?", true).order(:name).where("name like ?", "%#{params[:term]}%")
      render json: @customers.map(&:name)    
    end  

    protected
    
    #allow to create communication log with the customer
    def has_comm_log_right?
      grant_access?('comm_log', 'customerx_customers') 
    end
    
    #allow to create marketing lead
    def has_lead_right?
      grant_access?('lead', 'customerx_customers') 
    end
  
    #def return_users(actions, table_names, status = nil, utype = nil)
      # status is active by default. status =>'active', 'inactive', 'blocked' 
      #utype is employee by default, utype => 'emplyee', 'customer',...
    #  return [] if actions.nil? or table_names.nil?
      # actions & table_names, status & utype are string or array (more than one value)
   #   group_ids = Authentify::SysUserRight.where(:sys_action_on_table_id => Authentify::SysActionOnTable.where(:action => actions).
   #                                          where(:table_name => table_names).select("id")).select("sys_user_group_id")
    #  if utype.present?
    #    group_ids = Authentify::SysUserGroup.where(:user_type_desp => utype).where(:id => group_ids)
    #  end

    #  if status.nil? && utype.nil?
     #   Authentify::User.joins(:user_levels).where(:status => 'active').
     #                                        where(:authentify_user_levels => {:sys_user_group_id => group_ids})
     # elsif status.present? 
      #  Authentify::User.joins(:user_levels).where(:status => status).
     #                                        where(:authentify_user_levels => {:sys_user_group_id => group_ids})
      #end
   # end    

   #def return_last_contact_date(customer_id)
   #   log = Customerx::CommLog.where("customer_id = ?", customer_id).last
    #  return log.created_at unless log.nil?
   # end
    
  end
end
