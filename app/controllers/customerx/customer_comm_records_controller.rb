# encoding: utf-8
require_dependency "customerx/application_controller"

module Customerx
  class CustomerCommRecordsController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee
    before_filter :load_customer
    
    helper_method :contact_via, :has_void_right?
    
    def index
      @title= "客户联系记录"
      if has_index_right?("customerx_customer_comm_records")
        if @customer
          @customer_comm_records = @customer.customer_comm_records.where("comm_date > ?", 2.years.ago).order("comm_date DESC").page(params[:page]).per_page(30)
        else
          @customer_comm_records = Customerx::CustomerCommRecord.where("comm_date > ?", 2.years.ago).order("comm_date DESC").page(params[:page]).per_page(30)
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end      
    end
  
    def new
      @title= "新客户联系记录"
      if has_create_right?("customerx_customer_comm_records")
        if @customer
          @customer_comm_record = @customer.customer_comm_records.new()
        else
          @customer_comm_record = Customerx::CustomerCommRecord.new()
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
  
    def create
      if has_create_right?("customerx_customer_comm_records")
        if @customer
          @customer_comm_record = @customer.customer_comm_records.new(params[:customer_comm_record], :as => :role_new)
        else
          @customer_comm_record = Customerx::CustomerCommRecord.new(params[:customer_comm_record], :as => :role_new)
          cust = Customer.find_by_name(@customer_comm_record.customer_name_autocomplete) if @customer_comm_record.customer_name_autocomplete.present?
          @customer_comm_record.customer_id = cust.id if cust.present?
        end
        @customer_comm_record.last_updated_by_id = session[:user_id]
        @customer_comm_record.reported_by_id = session[:user_id]
        if @customer_comm_record.save
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Customer Communication Record Saved!")
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'new'
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")             
      end
    end
  
    def edit
      if has_update_right?("customerx_customer_comm_records")
        #@customer loaded with before_filter
        @customer_comm_record = Customerx::CustomerCommRecord.find_by_id(params[:id])
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
  
    def update
      if has_update_right?("customerx_customer_comm_records")
        @customer_comm_record = Customerx::CustomerCommRecord.find_by_id(params[:id])
        @customer_comm_record.last_updated_by_id = session[:user_id]
        if @customer_comm_record.update_attributes(params[:customer_comm_record], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Customer Comm Record Updated!")
        else
          flash.now[:error] = 'Data Error. Not Updated!'
          render 'edit'
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end
    end
  
    def show
      if has_show_right?("customerx_customer_comm_records")
        @customer_comm_record = Customerx::CustomerCommRecord.find_by_id(params[:id])
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
    
    protected
    
    def contact_via
      #phone call, meeting, fax, IM, email, letter (writing), online, other
      [['电话'],['会面'],['传真'],['电邮'],['即时信息IM'],['信件'],['互联网。如网络视频'],['其他']]
    end
    
    def has_void_right?
      grant_access?('void', 'customerx_customer_comm_records') 
    end
    
    def load_customer
      @customer = Customerx::Customer.find_by_id(params[:customer_id]) if params[:customer_id].present?
    end
  end
end
