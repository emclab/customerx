#encoding: utf-8
module Customerx
  class ApplicationController < ActionController::Base
    include Authentify::SessionsHelper
    include Authentify::AuthentifyUtility
    include Authentify::UserPrivilegeHelper
    include Authentify::UsersHelper
    
    helper_method :has_action_on_customer_comm_record?, :has_action_on_sales_lead?
    
    def return_yes_no_cn
      [['是',true ],['否', false]]
    end
    
    #allow to create communication log with the customer
    def has_action_on_customer_comm_record?(action, customer = nil) 
      #right: update, show
      return false if action.nil? 
      return true if grant_access?(action, 'customerx_customer_comm_records')
      if customer.present?
        return true if grant_access?(action + '_zone', 'customerx_customer_comm_records', nil, nil, customer.zone_id) #&& 
                       #session[:user_privilege].user_zone_ids.include?(customer.zone_id)
        return true if grant_access?(action + '_individual', 'customerx_customer_comm_records', customer) #&& session[:user_id] == customer.sales_id
      end 
    end
    
    #allow to create marketing lead
    def has_action_on_sales_lead?(action, customer = nil)
      #right: update, show
      return false if action.nil? 
      return true if grant_access?(action, 'customerx_sales_leads')
      if customer.present?
        return true if grant_access?(action + '_zone', 'customerx_sales_leads', nil, nil, customer.zone_id) #&& 
                      # session[:user_privilege].user_zone_ids.include?(customer.zone_id)
        return true if grant_access?(action + '_individual', 'customerx_sales_leads', customer) #&& session[:user_id] == customer.sales_id
      end
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

  end
end
