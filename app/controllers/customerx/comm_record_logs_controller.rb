# encoding: utf-8
require_dependency "customerx/application_controller"

module Customerx
  class CommRecordLogsController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee
    before_filter :load_customer_comm_record
    
    helper_method :has_index_individual_right?
    
    def index      
      if has_index_right?("customerx_comm_record_logs")  #all logs
        if @customer_comm_record
          @comm_record_logs = @customer_comm_record.comm_record_logs.where(:void => false).page(params[:page]).per_page(30).order("id DESC")
        else
          @comm_record_logs = Customerx::CommRecordLog.where(:void => false).where("created_at > ?", 2.years.ago).page(params[:page]).per_page(30).order("id DESC")
        end
      elsif has_index_individual_right?  #only display current user's
        if @customer_comm_record
          if grant_access?('index_individual', 'customerx_comm_record_logs', Customerx::Customer.find_by_id(@customer_comm_record.customer_id)) #if customer.sales_id == session[:user_id] 
            @comm_record_logs = @customer_comm_record.comm_record_logs.where(:void => false).page(params[:page]).per_page(30).order("id DESC")
          else
            redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
          end
        else
          #only display the logs belongs to the session[:user_id]
          record_ids = Customerx::CustomerCommRecord.where(:customer_id => Customerx::Customer.where(:sales_id => session[:user_id]).select("id")).
                                                     select("id")
          @comm_record_logs = Customerx::CommRecordLog.where(:void => false).where(:customer_comm_record_id => record_ids).
                                                       where("created_at > ?", 2.years.ago).page(params[:page]).per_page(30).order("id DESC")
        end
      else
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end      
    end
  
    def new
      if has_create_right?("customerx_comm_record_logs")
        #@customer_comm_record load with before filter
        @comm_record_log = @customer_comm_record.comm_record_logs.new()
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
  
    def create
      if has_create_right?("customerx_comm_record_logs")
        @comm_record_log = @customer_comm_record.comm_record_logs.new(params[:comm_record_log], :as => :role_new)
        @comm_record_log.last_updated_by_id = session[:user_id]
        if @comm_record_log.save
          redirect_to customer_customer_comm_record_path(@customer_comm_record.customer, @customer_comm_record), :notice => "Comm Record Log Saved!"
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'new'
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end
    end
    
    protected
    
    def has_index_individual_right?
      grant_access?('index_individual', 'customerx_comm_record_logs')
    end
    
    def load_customer_comm_record
      @customer_comm_record = Customerx::CustomerCommRecord.find_by_id(params[:customer_comm_record_id]) if params[:customer_comm_record_id].present?
    end
  end
end
