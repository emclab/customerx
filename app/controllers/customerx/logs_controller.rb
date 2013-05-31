require_dependency "customerx/application_controller"

module Customerx
  class LogsController < ApplicationController    
    #@which_table : 'sales_lead', 'customer_comm_record'
    #right on customerx_logs:
    #index_sales_lead, index_customer_comm_record
    #index_zone_sales_lead, index_zone_customer_comm_record
    #index_individual_sales_lead, index_individual_customer_comm_record
    #create_sales_lead, create_customer_comm_record.  create logs
    #before_filter :require_signin
    before_filter :require_employee
    before_filter :load_sales_lead
    before_filter :load_customer_comm_record
    before_filter :require_which_table, :only => [:index, :new, :create]  #which_table holds the table name which the log belongs to
    before_filter :load_session_variable, :only => [:new, :edit]
    after_filter :delete_session_variable, :only => [:create, :update] 
    
    def index
      #if @which_table == 'sales_lead' 
        #sales_lead_logs()
      #elsif @which_table == 'customer_comm_record' 
        #customer_comm_record_logs()
      if @sales_lead
        @logs = @sales_lead.logs.page(params[:page]).per_page(@max_pagination).order('id DESC')
      elsif @customer_comm_record
        @logs = @customer_comm_record.logs.page(params[:page]).per_page(@max_pagination).order('id DESC')
      elsif @which_table == 'customer_comm_record'
        @logs = params[:customerx_logs][:model_ar_r].where("customerx_logs.customer_comm_record_id > ?", 0).page(params[:page]).per_page(@max_pagination)
      elsif @which_table == 'sales_lead'
        @logs = params[:customerx_logs][:model_ar_r].where("customerx_logs.sales_lead_id > ?", 0).page(params[:page]).per_page(@max_pagination)
      else
        #@which_table does not match any
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Table Name Not Match!")
      end
    end
  
    def new
      #session[:which_table] = @which_table
      #session[:subaction] = @which_table
      if @which_table == 'sales_lead' 
        if  @sales_lead
          @log = @sales_lead.logs.new()
        else
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO sales lead selected for log!")
        end
      elsif @which_table == 'customer_comm_record' #&& grant_access?('create_customer_comm_record', 'customerx_logs')
        if @customer_comm_record
          @log = @customer_comm_record.logs.new()
        else
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO customer comm record selected for log!")
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")  
      end
    end
  
    def create
      #if grant_access?('create_sales_lead', 'customerx_logs') || grant_access?('create_customer_comm_record', 'customerx_logs')
        #session.delete(:subaction) #subaction used in check_access_right in authentify
        if session[:which_table] == 'sales_lead' && @sales_lead
          @log = @sales_lead.logs.new(params[:log], :as => :role_new)
          data_save = true
        elsif session[:which_table] == 'customer_comm_record' && @customer_comm_record
          @log = @customer_comm_record.logs.new(params[:log], :as => :role_new)
          data_save = true
        else
          #session.delete(:which_table)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO parental object selected!")
        end
        #session.delete(:which_table)
        if data_save  #otherwise @log.save will be executed no matter what.
          @log.last_updated_by_id = session[:user_id]
          if @log.save
            redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Log Saved!")
          else
            flash.now[:error] = 'Data Error. Not Saved!'
            render 'new'
          end
        end
      
    end
  
    def destroy
    end
    
    protected
    
    def require_which_table
      @which_table = params[:which_table]
      unless @which_table == 'sales_lead' || @which_table == 'customer_comm_record'
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Initial Params Error!") 
      end
    end
  
    def load_sales_lead
      @sales_lead = Customerx::SalesLead.find_by_id(params[:sales_lead_id]) if params[:sales_lead_id].present? && 
                                                                               params[:sales_lead_id].to_i > 0
    end
    
    def load_customer_comm_record
      @customer_comm_record = Customerx::CustomerCommRecord.find_by_id(params[:customer_comm_record_id]) if params[:customer_comm_record_id].present? && 
                               params[:customer_comm_record_id].to_i > 0 
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
