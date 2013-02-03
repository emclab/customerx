# encoding: utf-8
require_dependency "customerx/application_controller"

module Customerx
  class QualitySystemsController < ApplicationController
    
    before_filter :require_signin
    before_filter :require_employee
    
    helper_method 
    
    def index
      @title = 'Quality System'
      if has_create_right?('customerx_quality_systems') || has_update_right?('customerx_quality_systems')
        @quality_systems = Customerx::QualitySystem.order("ranking_order")
      else
        @quality_systems = Customerx::QualitySystem.where('active = ?', true).order("ranking_order")
      end
    end

    def new
      @title = 'New Quality System'
      if has_create_right?('customerx_quality_systems')
        @quality_system = Customerx::QualitySystem.new()
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
    
    def create
      if has_create_right?('customerx_quality_systems')
        @quality_system = Customerx::QualitySystem.new(params[:quality_system], :as => :role_new)
        @quality_system.last_updated_by_id = session[:user_id]
        if @quality_system.save
          redirect_to quality_systems_path, :notice => "Quality System Saved!"
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'new'
        end
      end
    end
    
    def edit
      @title = 'Update Qualty System'
      if has_update_right?('customerx_quality_systems')
        @quality_system = Customerx::QualitySystem.find(params[:id])
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
  
    def update
      if has_update_right?('customerx_quality_systems')
        @quality_system = Customerx::QualitySystem.find(params[:id])
        @quality_system.last_updated_by_id = session[:user_id]
        if @quality_system.update_attributes(params[:quality_system], :as => :role_update)
          redirect_to quality_systems_path, :notice => "Quality System Updated!"
        else
          flash.now[:error] = 'Data Error. Not Updated!'
          render 'edit'
        end
      end      
    end

    protected
    
  end
end
