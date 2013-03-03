require_dependency "customerx/application_controller"

module Customerx
  class LeadLogsController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee
    before_filter :load_sales_lead
 
    def index
      if has_index_right?("customerx_lead_logs")
        if @sales_lead
          @lead_logs = @sales_lead.lead_logs.order('id DESC')
        else
          @lead_logs = Customerx::LeadLog.order('id DESC')
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")  
      end
    end
  
    def new
      if has_create_right?("customerx_lead_logs")
        if @sales_lead
          @lead_log = @sales_lead.lead_logs.new()
        else
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Sales Lead selected!")
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")  
      end
    end
  
    def create
      if has_create_right?("customerx_lead_logs")
        if @sales_lead
          @lead_log = @sales_lead.lead_logs.new(params[:lead_log], :as => :role_new)
          @lead_log.last_updated_by_id = session[:user_id]
          if @lead_log.save
            redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Lead Log Saved!")
          else
            flash.now[:error] = 'Data Error. Not Saved!'
            render 'new'
          end
        else
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Sales Lead selected!")
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end
    end
    
    protected 
    
    def load_sales_lead
      @sales_lead = Customerx::SalesLead.find_by_id(params[:sales_lead_id]) if params[:sales_lead_id].present?
    end
  end
end
