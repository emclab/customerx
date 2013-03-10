# encoding: utf-8
require_dependency "customerx/application_controller"

module Customerx
  class MiscDefinitionsController < ApplicationController
    #right:
    #create_customer_status, create_customer_quality_system, create_customer_comm_category, create_sales_lead_source
    #update_customer_status, update_customer_quality_system, update_customer_comm_category, update_sales_lead_source
    #for_which
    #customer_status, customer_qs, customer_comm_category, sales_lead_source
    before_filter :require_signin
    before_filter :require_employee
    before_filter :require_for_which, :only => [:index, :new, :edit]  #for_which holds the table name which the log belongs to
    
    helper_method 
    
    def index
      @title = title('index', @for_which)
      if @for_which == 'customer_status' #customer category 
        customer_status_category()
      elsif @for_which == 'customer_comm_category'
        customer_comm_category()
      elsif @for_which == 'customer_qs'
        quality_system_for_customer()
      elsif @for_which == 'sales_lead_source'
        sales_lead_source()
      else
        #@for_which does not match any
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Table Name Not Match!")
      end
      
    end

    def new
      @title = title('new', @for_which)
      if grant_access?('create_customer_status', 'customerx_misc_definitions') ||
         grant_access?('create_customer_quality_system', 'customerx_misc_definitions') ||
         grant_access?('create_customer_comm_category', 'customerx_misc_definitions') ||
         grant_access?('create_sales_lead_source', 'customerx_misc_definitions')
        @misc_definition = Customerx::MiscDefinition.new()
        @misc_definition.for_which = @for_which
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
    
    def create
      if grant_access?('create_customer_status', 'customerx_misc_definitions') || 
         grant_access?('create_customer_comm_category', 'customerx_misc_definitions') || 
         grant_access?('create_customer_quality_system', 'customerx_misc_definitions') || 
         grant_access?('create_sales_lead_source', 'customerx_misc_definitions')
        @misc_definition = Customerx::MiscDefinition.new(params[:misc_definition], :as => :role_new)
        #@misc_definition.for_which = @for_which
        @misc_definition.last_updated_by_id = session[:user_id]
        if @misc_definition.save
          redirect_to misc_definitions_path(:for_which => @misc_definition.for_which), :notice => "Definition Saved!"
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'new'
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end
    end
    
    def edit      
      @title = title('edit', @for_which)
      if grant_access?('update_customer_status', 'customerx_misc_definitions') ||
         grant_access?('update_customer_quality_system', 'customerx_misc_definitions') ||
         grant_access?('update_customer_comm_category', 'customerx_misc_definitions') ||
         grant_access?('update_sales_lead_source', 'customerx_misc_definitions')
         @misc_definition = Customerx::MiscDefinition.find(params[:id])
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
  
    def update
      if grant_access?('update_customer_status', 'customerx_misc_definitions') ||
         grant_access?('update_customer_quality_system', 'customerx_misc_definitions') ||
         grant_access?('update_customer_comm_category', 'customerx_misc_definitions') ||
         grant_access?('update_sales_lead_source', 'customerx_misc_definitions')
        @misc_definition = Customerx::MiscDefinition.find(params[:id])
        @misc_definition.last_updated_by_id = session[:user_id]
        if @misc_definition.update_attributes(params[:misc_definition], :as => :role_update)
          redirect_to misc_definitions_path(:for_which => @misc_definition.for_which), :notice => "Definition Updated!"
        else
          flash.now[:error] = 'Data Error. Not Updated!'
          render 'edit'
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end      
    end

    protected
    
    def customer_status_category
      if grant_access?('create_customer_status', 'customerx_misc_definitions') || 
         grant_access?('update_customer_status', 'customerx_misc_definitions')
        @misc_definitions = Customerx::MiscDefinition.where(:for_which => 'customer_status').order("ranking_order")
      else
        @misc_definitions = Customerx::MiscDefinition.where('active = ?', true).where(:for_which => 'customer_status').order("ranking_order")
      end
    end
    
    def customer_comm_category
      if grant_access?('create_customer_comm_category', 'customerx_misc_definitions') || 
         grant_access?('update_customer_comm_category', 'customerx_misc_definitions')
        @misc_definitions = Customerx::MiscDefinition.where(:for_which => 'customer_comm_category').order("ranking_order")
      else
        @misc_definitions = Customerx::MiscDefinition.where('active = ?', true).where(:for_which => 'customer_comm_category').order("ranking_order")
      end
    end
    
    def quality_system_for_customer
      if grant_access?('create_customer_quality_system', 'customerx_misc_definitions') || 
         grant_access?('update_customer_quality_system', 'customerx_misc_definitions')
        @misc_definitions = Customerx::MiscDefinition.where(:for_which => 'customer_qs').order("ranking_order")
      else
        @misc_definitions = Customerx::MiscDefinition.where('active = ?', true).where(:for_which => 'customer_qs').order("ranking_order")
      end
    end
    
    def sales_lead_source
      if grant_access?('create_sales_lead_source', 'customerx_misc_definitions') || 
         grant_access?('update_sales_lead_source', 'customerx_misc_definitions')
        @misc_definitions = Customerx::MiscDefinition.where(:for_which => 'sales_lead_source').order("ranking_order")
      else
        @misc_definitions = Customerx::MiscDefinition.where('active = ?', true).where(:for_which => 'sales_lead_source').order("ranking_order")
      end
    end
    
    def require_for_which     
      @for_which = params[:for_which] if params[:for_which].present?
      @for_which = Customerx::MiscDefinition.find_by_id(params[:id]).for_which if params[:id].present?
      unless @for_which == 'customer_status' || @for_which == 'customer_comm_category' || @for_which == 'customer_qs' || @for_which == 'sales_lead_source'
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Initial Params Error!") 
      end
    end
    
    def title(action, for_which)
      if action == 'index'
        return "Customer Status Categories" if for_which == 'customer_status'
        return "Customer Comm Categories" if for_which == 'customer_comm_category'
        return "Quality Systems" if for_which == 'customer_qs'
        return "Sales Lead Sources" if for_which == 'sales_lead_source'
      elsif action == 'new'
        return "New Customer Status Category" if for_which == 'customer'
        return "New Customer Comm Category" if for_which == 'customer_comm_category'
        return "New Quality System" if for_which == 'customers_qs'
        return "New Sales Lead Source" if for_which == 'sales_lead_source'
      elsif action == 'edit'
        return "Update Customer Status Category" if for_which == 'customer_status'
        return "Update Customer Comm Category" if for_which == 'customer_comm_category'
        return "Update Quality System" if for_which == 'customer_qs'
        return "Update Sales Lead Source" if for_which == 'sales_lead_source'
      end
    end
  end
end