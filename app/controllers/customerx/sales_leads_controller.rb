# encoding: utf-8
require_dependency "customerx/application_controller"

module Customerx
  class SalesLeadsController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee
    before_filter :load_customer
    
    helper_method :lead_sources
    
    def index
      if has_index_right?('customerx_sales_leads')
        if @customer
          @sales_leads = @customer.sales_leads.where("created_at > ?", 2.year.ago).order("created_at DESC").page(params[:page]).per_page(30)
        else
          @sales_leads = Customerx::SalesLead.where("created_at > ?", 2.year.ago).order("created_at DESC").page(params[:page]).per_page(30)
        end 
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")   
      end
    end
  
    def new
      if has_create_right?('customerx_sales_leads')
        if @customer
          @sales_lead = @customer.sales_leads.new()
        else
          @sales_lead = Customerx::SalesLead.new()
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
  
    def create
      if has_create_right?('customerx_sales_leads')
        if @customer
          @sales_lead = @customer.sales_leads.new(params[:sales_lead], :as => :role_new)
          @sales_lead.last_updated_by_id = session[:user_id]
        else
          @sales_lead = Customerx::SalesLead.new(params[:sales_lead], :as => :role_new)
          cust = Customerx::Customer.find_by_name(@sales_lead.customer_name_autocomplete) if @sales_lead.customer_name_autocomplete.present?
          @sales_lead.customer_id = cust.id if cust.present?
        end
        #provider id from autocomplete
        provider = Authentify::User.find_by_name(@sales_lead.provider_name_autocomplete) if @sales_lead.provider_name_autocomplete.present?
        @sales_lead.provider_id = provider.id if provider.present?
        @sales_lead.last_updated_by_id = session[:user_id]
        if @sales_lead.save
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Sales Lead Saved!")
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'new'
        end
      end
    end
  
    def edit
      if has_update_right?('customerx_sales_leads')
        if @customer
          @sales_lead = Customerx::SalesLead.find_by_id(params[:id])
        else
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO customer selected!")
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
  
    def update
      if has_update_right?('customerx_sales_leads')
        @sales_lead = Customerx::SalesLead.find_by_id(params[:id])
        #provider id from autocomplete
        provider = Authentify::User.find_by_name(@sales_lead.provider_name_autocomplete) if @sales_lead.provider_name_autocomplete.present?
        @sales_lead.provider_id = provider.id if provider.present?        
        @sales_lead.last_updated_by_id = session[:user_id]
        params[:sales_lead][:initial_order_total] = '' if params[:sales_lead][:sale_success] == 'false'
        if @sales_lead.update_attributes(params[:sales_lead], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Sales Lead Updated!")
        else
          flash.now[:error] = 'Data Error. Not Updated!'
          render 'edit'
        end
      end
    end
  
    def show
      if has_show_right?('customerx_sales_leads')
        if @customer
          @sales_lead = Customerx::SalesLead.find_by_id(params[:id])
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
    
    protected
        
    def lead_sources
      Customerx::LeadSource.active.order("ranking_order")
    end
    
    def load_customer
      @customer = Customerx::Customer.find_by_id(params[:customer_id]) if params[:customer_id].present?
    end
  end
end
