# encoding: utf-8
require_dependency "customerx/application_controller"

module Customerx
  class SalesLeadsController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee
    before_filter :load_customer
    
    helper_method :lead_sources
    
    def index
      if has_action_on_sales_lead?('index', @customer)
        if @customer
          @sales_leads = @customer.sales_leads.where("lead_date > ?", 2.year.ago).order("lead_date DESC").page(params[:page]).per_page(30)
        else
          has_right = true
          params[:sales_lead] = {}
          if grant_access?('index', 'customerx_sales_leads')
            params[:sales_lead] = {} 
          elsif grant_access?('index_zone', 'customerx_sales_leads')
            params[:sales_lead][:zone_id_s] = session[:user_privilege].user_zone_ids         
          elsif grant_access?('index_individual', 'customerx_sales_leads')
            params[:sales_lead][:sales_id_s] = session[:user_id]
          else
            has_right = false
            redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")    
          end
          if has_right
            record = Customerx::SalesLead.new(params[:sales_lead], :as => :role_search_stats)
            @sales_leads = record.find_sales_leads.where("lead_date > ?", 2.years.ago).order("lead_date DESC").page(params[:page]).per_page(30)
          end
        end 
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")   
      end
    end
  
    def new
      if grant_access?('create', 'customerx_sales_leads')
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
      if grant_access?('create', 'customerx_sales_leads')
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
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end
    end
  
    def edit
      #nested with customer
      if has_action_on_sales_lead?('update', @customer) && @customer
        @sales_lead = Customerx::SalesLead.find_by_id(params[:id])
      elsif @customer.blank?
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Missing Customer!")
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
  
    def update
      if has_action_on_sales_lead?('update', @customer) && @customer
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
      elsif @customer.blank?
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Missing Customer!")  
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end
    end
  
    def show
      #nested with customer
      if has_action_on_sales_lead?('show', @customer)
        @sales_lead = Customerx::SalesLead.find_by_id(params[:id])
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
    
    protected
        
    def lead_sources
      Customerx::MiscDefinition.where(:for_which => 'sales_lead_source').where(:active => true).order("ranking_order")
    end
    
    def load_customer
      @customer = Customerx::Customer.find_by_id(params[:customer_id]) if params[:customer_id].present?
    end
  end
end
