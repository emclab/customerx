# encoding: utf-8
require_dependency "customerx/application_controller"

module Customerx
  class SalesLeadsController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee
    
    def index
      if has_index_right?
        if @customer
          @sales_leads = @customer.sales_leads.where("created_at > ?", 2.year.ago).order("created_at DESC").page(parasm[:page]).per_page(30)
        else
          @sales_leads = Customerx::SalesLead.where("created_at > ?", 2.year.ago).order("created_at DESC").page(parasm[:page]).per_page(30)
        end 
      end
    end
  
    def new
    end
  
    def create
    end
  
    def edit
    end
  
    def update
    end
  
    def show
    end
    
    protected
    
    def has_index_right?
      grant_access?('index', 'customerx_customers')  #heritage the right for customers table
    end
    
    def load_customer
      @customer = Customerx::Customer.find_by_id(params[:customer_id]) if params[:customer_id].present?
    end
  end
end
