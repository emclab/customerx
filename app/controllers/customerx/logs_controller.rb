require_dependency "customerx/application_controller"

module Customerx
  class LogsController < ApplicationController
    #right on customerx_logs:
    #index_sales_lead, index_customer_comm_record
    #index_zone_sales_lead, index_zone_customer_comm_record
    #index_individual_sales_lead, index_individual_customer_comm_record
    #create_sales_lead, create_customer_comm_record.  create logs
    before_filter :require_signin
    before_filter :require_employee
    before_filter :load_sales_lead
    before_filter :load_customer_comm_record
    before_filter :require_which_table, :only => [:index, :new]  #which_table holds the table name which the log belongs to
    def index
      if @which_table == 'sales_lead' 
        sales_lead_logs()
      elsif @which_table == 'customer_comm_record' 
        customer_comm_record_logs()
      else
        #@which_table does not match any
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Table Name Not Match!")
      end
    end
  
    def new
      if @which_table == 'sales_lead' && grant_access?('create_sales_lead', 'customerx_logs')
        if  @sales_lead
          @log = @sales_lead.logs.new()
        else
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO sales lead selected for log!")
        end
      elsif @which_table == 'customer_comm_record' && grant_access?('create_customer_comm_record', 'customerx_logs')
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
      if grant_access?('create_sales_lead', 'customerx_logs') || grant_access?('create_customer_comm_record', 'customerx_logs')
        if params[:log][:which_table] == 'sales_lead' && @sales_lead
          @log = @sales_lead.logs.new(params[:log], :as => :role_new)
          data_save = true
        elsif params[:log][:which_table] == 'customer_comm_record' && @customer_comm_record
          @log = @customer_comm_record.logs.new(params[:log], :as => :role_new)
          data_save = true
        else
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO parental object selected!")
        end
        if data_save  #otherwise @log.save will be executed no matter what.
          @log.last_updated_by_id = session[:user_id]
          if @log.save
            redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Log Saved!")
          else
            flash.now[:error] = 'Data Error. Not Saved!'
            render 'new'
          end
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end
    end
  
    def destroy
    end
    
    protected
    
    def sales_lead_logs
      if grant_access?('index_individual_sales_lead', 'customerx_logs')  #only display current user's log
        logs_for_index_individual_right(@sales_lead)
      elsif grant_access?('index_zone_sales_lead', 'customerx_logs')
        logs_for_index_zone_right(@sales_lead)
      elsif grant_access?('index_sales_lead', 'customerx_logs')
        logs_for_index_right(@sales_lead)
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")  
      end
    end
    
    def customer_comm_record_logs
      if grant_access?('index_individual_customer_comm_record', 'customerx_logs')  #only display current user's
        logs_for_index_individual_right(@customer_comm_record)
      elsif grant_access?('index_zone_customer_comm_record', 'customerx_logs')
        logs_for_index_zone_right(@customer_comm_record)
      elsif grant_access?('index_customer_comm_record', 'customerx_logs')  #all logs
        logs_for_index_right(@customer_comm_record)
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end      
    end
        
    def logs_for_index_right(parent_obj)
      if parent_obj
        @logs = parent_obj.logs.page(params[:page]).per_page(30).order("id DESC")
      else
        @logs = Customerx::Log.where(:which_table => @which_table).where("created_at > ?", 2.years.ago).page(params[:page]).per_page(30).order("id DESC")
      end
    end
    
    def logs_for_index_zone_right(parent_obj)
      if parent_obj
        if (@which_table == 'sales_lead' && grant_access?('index_zone_sales_lead', 'customerx_logs', nil, nil, parent_obj.customer.zone_id)) ||
           (@which_table == 'customer_comm_record' && grant_access?('index_zone_customer_comm_record', 'customerx_logs', nil, nil, parent_obj.customer.zone_id))
          @logs = parent_obj.logs.page(params[:page]).per_page(30).order("id DESC")
        else
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
        end
      else
        if @which_table == 'customer_comm_record' && grant_access?('index_zone_customer_comm_record', 'customerx_logs')
          customer_comm_record_ids = Customerx::CustomerCommRecord.joins(:customer).
                                     where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids}).select("customerx_customer_comm_records.id")
          @logs = Customerx::Log.where(:customer_comm_record_id => customer_comm_record_ids).page(params[:page]).per_page(30).order('id DESC')
        elsif @which_table == 'sales_lead' && grant_access?('index_zone_sales_lead', 'customerx_logs')
          sales_lead_ids = Customerx::SalesLead.joins(:customer).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids}).select("customerx_sales_leads.id")
          @logs = Customerx::Log.where(:sales_lead_id => sales_lead_ids).page(params[:page]).per_page(30).order('id DESC')
        else
          @logs = []
        end        
      end
    end
    
    def logs_for_index_individual_right(parent_obj)
      if parent_obj
        if grant_access?('index_individual_sales_lead', 'customerx_logs', Customerx::Customer.find_by_id(parent_obj.customer_id)) #if customer.sales_id == session[:user_id] 
          @logs = Customerx::Log.where("which_table = ? AND sales_lead_id = ?", 'sales_lead', parent_obj.id).page(params[:page]).per_page(30).order("id DESC")
        elsif grant_access?('index_individual_customer_comm_record', 'customerx_logs', Customerx::Customer.find_by_id(parent_obj.customer_id)) #if customer.sales_id == session[:user_id]
          @logs = Customerx::Log.where("which_table = ? AND customer_comm_record_id = ?", 'customer_comm_record', parent_obj.id).page(params[:page]).per_page(30).order("id DESC")
        else
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
        end
      else
        if @which_table == 'customer_comm_record'
          #only display the logs belongs to the session[:user_id]
          record_ids = Customerx::CustomerCommRecord.where(:customer_id => Customerx::Customer.where(:sales_id => session[:user_id]).select("id")).
                                                   select("id")       
          @logs = Customerx::Log.where(:customer_comm_record_id => record_ids).
                                where("created_at > ?", 2.years.ago).page(params[:page]).per_page(30).order("id DESC")
        elsif @which_table == 'sales_lead'
          #only display the logs belongs to the session[:user_id]
          record_ids = Customerx::SalesLead.where(:customer_id => Customerx::Customer.where(:sales_id => session[:user_id]).select("id")).
                                                     select("id")
          @logs = Customerx::Log.where(:sales_lead_id => record_ids).
                                 where("created_at > ?", 2.years.ago).page(params[:page]).per_page(30).order("id DESC")
        else
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Missing Data!")                         
        end
      end
    end
    
    def require_which_table
      @which_table = params[:which_table]
      unless @which_table == 'sales_lead' || @which_table == 'customer_comm_record'
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Initial Params Error!") 
      end
    end
    
    def has_index_individual_right?
      grant_access?('index_individual', 'customerx_logs')
    end
    
    def load_sales_lead
      @sales_lead = Customerx::SalesLead.find_by_id(params[:sales_lead_id]) if params[:sales_lead_id].present?
    end
    
    def load_customer_comm_record
      @customer_comm_record = Customerx::CustomerCommRecord.find_by_id(params[:customer_comm_record_id]) if params[:customer_comm_record_id].present?
    end
  end
end
