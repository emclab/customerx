require_dependency "customerx/application_controller"

module Customerx
  class LeadSourcesController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee
    
    helper_method :has_create_right?, :has_update_right?
    
    def index
      @title = 'Lead Sources'
      if has_create_right? || has_update_right?
        @lead_sources = Customerx::LeadSource.order("ranking_order")
      else
        @lead_sources = Customerx::LeadSource.where('active = ?', true).order("ranking_order")
      end
    end

    def new
      @title = 'New Lead Source'
      if has_create_right?
        @lead_source = Customerx::LeadSource.new()
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
    
    def create
      if has_create_right?
        @lead_source = Customerx::LeadSource.new(params[:lead_source], :as => :role_new)
        @lead_source.last_updated_by_id = session[:user_id]
        if @lead_source.save
          redirect_to lead_sources_path, :notice => "Quality System Saved!"
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'new'
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end
    end
    
    def edit
      @title = 'Update Lead Source'
      if has_update_right?
        @lead_source = Customerx::LeadSource.find(params[:id])
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
  
    def update
      if has_update_right?
        @lead_source = Customerx::LeadSource.find(params[:id])
        @lead_source.last_updated_by_id = session[:user_id]
        if @lead_source.update_attributes(params[:lead_source], :as => :role_update)
          redirect_to lead_sources_path, :notice => "Lead Source Updated!"
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'edit'
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end      
    end

    protected
    
    def has_create_right?
      grant_access?('create', 'customerx_lead_sources')
    end

    def has_update_right?
      grant_access?('update', 'customerx_lead_sources')
    end
  end
end
