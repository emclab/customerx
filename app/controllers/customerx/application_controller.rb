#encoding: utf-8
module Customerx
  class Customerx::ApplicationController < ApplicationController
    include Authentify::SessionsHelper
    include Authentify::AuthentifyUtility
    include Authentify::UserPrivilegeHelper
    include Authentify::UsersHelper
    include Commonx::CommonxHelper
    
    before_filter :require_signin
    before_filter :max_pagination 
    before_filter :check_access_right 
    before_filter :load_session_variable, :only => [:new, :edit]  #for parent_record_id & parent_resource in check_access_right
    after_filter :delete_session_variable, :only => [:create, :update]   #for parent_record_id & parent_resource in check_access_right 
    
    helper_method   #:has_action_right?, :print_attribute, :readonly?
    #helper_method :has_action_on_customer_comm_record?, :has_action_on_sales_lead?
    
    def search
      @title = params[:controller].camelize.demodulize.tableize.singularize.capitalize + ' Search'  
      @model, @search_stat = Commonx::CommonxHelper.search(params)
      @results_url = 'search_results_' + params[:controller].camelize.demodulize.tableize.downcase + '_path'
      @erb_code = find_config_const('search_params_view')
    end

    def search_results
      @title = params[:controller].camelize.demodulize.tableize.singularize.capitalize + ' Search'
      @s_s_results_details =  Commonx::CommonxHelper.search_results(params, @max_pagination)
      @erb_code = find_config_const(params[:controller].camelize.demodulize.tableize.singularize.downcase + '_index_view', params[:controller].camelize.deconstantize.tableize.singularize.downcase)
    end
    
    def stats
      @title = params[:controller].camelize.demodulize.tableize.singularize.capitalize + ' Stats' 
      @model, @search_stat = Commonx::CommonxHelper.search(params)
      @results_url = 'stats_results_' + params[:controller].camelize.demodulize.tableize.downcase + '_path'
      @erb_code = find_config_const('stats_params_view')
    end

    def stats_results
      @title = params[:controller].camelize.demodulize.tableize.singularize.capitalize + ' Stats' 
      @s_s_results_details =  Commonx::CommonxHelper.search_results(params, @max_pagination)
      @time_frame = eval(@s_s_results_details.time_frame)
      @erb_code = find_config_const(params[:controller].camelize.demodulize.tableize.singularize.downcase + '_index_view', params[:controller].camelize.deconstantize.tableize.singularize.downcase)
    end
    
    def return_yes_no_cn
      [['是',true ],['否', false]]
    end
    
    def link_to_remove_fields(name, f)
      f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
    end
  
    def link_to_add_fields(name, f, association)
      new_object = f.object.class.reflect_on_association(association).klass.new
      fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
        render :partial => association.to_s, :locals => {:f => builder, :i_id => 0} 
      end
      link_to_function(name, "add_fields(this, \"#{association}\", \"#{j fields}\")")
    end
    
    protected
  
    def max_pagination
      @max_pagination = find_config_const('pagination')
    end
    
  end
end
