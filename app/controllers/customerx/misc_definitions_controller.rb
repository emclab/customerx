# encoding: utf-8
require_dependency "customerx/application_controller"

module Customerx
  class MiscDefinitionsController < ApplicationController
    #right:
    #create_customer_status, create_customer_quality_system, create_customer_comm_category, create_sales_lead_source
    #update_customer_status, update_customer_quality_system, update_customer_comm_category, update_sales_lead_source
    #for_which
    #customer_status, customer_quality_system, customer_comm_category, sales_lead_source
    #before_filter :require_signin
    before_filter :require_employee
    before_filter :require_for_which, :only => [:index, :new, :edit]  
    before_filter :load_session_variable, :only => [:new, :edit]
    after_filter :delete_session_variable, :only => [:create, :update] 
    
    helper_method 
    
    def index
      @title = title('index', @for_which)
      #sql_code needs to pull out all misc_definitions and sort here. before_filter check_access_right does not take a params.
      #@for_which: 'customer_status', 'customer_comm_category', 'customer_qs', 'sales_lead_source'
      if @for_which
        @misc_definitions = params[:customerx_misc_definitions][:model_ar_r].where(:for_which => @for_which).page(params[:page]).per_page(@max_pagination)
      else
      #@for_which does not match any
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Table Name Not Match!")
      end
    end

    def new
      @title = title('new', @for_which)
     # if has_action_right?('create_customer_status', 'customerx_misc_definitions') ||
      #   has_action_right?('create_customer_quality_system', 'customerx_misc_definitions') ||
      #   has_action_right?('create_customer_comm_category', 'customerx_misc_definitions') ||
      #   has_action_right?('create_sales_lead_source', 'customerx_misc_definitions')
      params[:misc_definition] = {}
      @misc_definition = Customerx::MiscDefinition.new()
      params[:misc_definition][:for_which] = @for_which
      #session[:for_which] = @for_which
      #session[:subaction] = params[:subaction]

      #else
      #  redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      #end
    end
    
    def create
      @misc_definition = Customerx::MiscDefinition.new(params[:misc_definition], :as => :role_new)
      @misc_definition.for_which = session[:for_which]
      @misc_definition.last_updated_by_id = session[:user_id]
      #session.delete(:for_which)
      #session.delete(:subaction)
      if @misc_definition.save
        redirect_to misc_definitions_path(:for_which => @misc_definition.for_which, :subaction => @misc_definition.for_which), :notice => "Definition Saved!"
      else
        flash.now[:error] = 'Data Error. Not Saved!'
        render 'new'
      end

    end
    
    def edit      
      @title = title('edit', @for_which)
      #if has_action_right?('update_customer_status', 'customerx_misc_definitions') ||
      #   has_action_right?('update_customer_quality_system', 'customerx_misc_definitions') ||
      #   has_action_right?('update_customer_comm_category', 'customerx_misc_definitions') ||
       #  has_action_right?('update_sales_lead_source', 'customerx_misc_definitions')
      @misc_definition = Customerx::MiscDefinition.find(params[:id])
      #session[:subaction] = params[:subaction]
      #else
      #  redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      #end
    end
  
    def update
     # if has_action_right?('update_customer_status', 'customerx_misc_definitions') ||
      #   has_action_right?('update_customer_quality_system', 'customerx_misc_definitions') ||
     #    has_action_right?('update_customer_comm_category', 'customerx_misc_definitions') ||
      #   has_action_right?('update_sales_lead_source', 'customerx_misc_definitions')
        @misc_definition = Customerx::MiscDefinition.find(params[:id])
        @misc_definition.last_updated_by_id = session[:user_id]
        #session.delete(:subaction)
        if @misc_definition.update_attributes(params[:misc_definition], :as => :role_update)
          redirect_to misc_definitions_path(:for_which => @misc_definition.for_which, :subaction => @misc_definition.for_which), :notice => "Definition Updated!"
        else
          flash.now[:error] = 'Data Error. Not Updated!'
          render 'edit'
        end
     # else
      #  redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
     # end      
    end

    protected
    
    def require_for_which     
      @for_which = params[:for_which] if params[:for_which].present?
      @for_which = Customerx::MiscDefinition.find_by_id(params[:id]).for_which if params[:id].present?
      unless @for_which == 'customer_status' || @for_which == 'customer_comm_category' || @for_which == 'customer_quality_system' || @for_which == 'sales_lead_source'
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Initial Params Error!") 
      end
    end
    
    def title(action, for_which)
      if action == 'index'
        return "Customer Status Categories" if for_which == 'customer_status'
        return "Customer Comm Categories" if for_which == 'customer_comm_category'
        return "Quality Systems" if for_which == 'customer_quality_system'
        return "Sales Lead Sources" if for_which == 'sales_lead_source'
      elsif action == 'new'
        return "New Customer Status Category" if for_which == 'customer_status'
        return "New Customer Comm Category" if for_which == 'customer_comm_category'
        return "New Quality System" if for_which == 'customer_quality_system'
        return "New Sales Lead Source" if for_which == 'sales_lead_source'
      elsif action == 'edit'
        return "Update Customer Status Category" if for_which == 'customer_status'
        return "Update Customer Comm Category" if for_which == 'customer_comm_category'
        return "Update Quality System" if for_which == 'customer_quality_system'
        return "Update Sales Lead Source" if for_which == 'sales_lead_source'
      end
    end
    
    def load_session_variable
      session[:for_which] = @for_which if @for_which.present?
      session[:which_table] = @which_table if @which_table.present?
      session[:subaction] = params[:subaction] if params[:subaction].present?
    end
    
    def delete_session_variable
      session.delete(:which_table) if session[:which_table].present?
      session.delete(:for_which) if session[:for_which].present?
      session.delete(:subaction) if session[:subaction].present?
    end
    
  end
end