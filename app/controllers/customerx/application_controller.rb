#encoding: utf-8
module Customerx
  class ApplicationController < ActionController::Base
    include Authentify::SessionsHelper
    include Authentify::AuthentifyUtility
    include Authentify::UserPrivilegeHelper
    include Authentify::UsersHelper
    
    helper_method :has_index_right?, :has_create_right?, :has_update_right?, :has_show_right?, :has_destroy_right?, :has_activate_right?, :return_yes_no_cn,
                  :has_search_right?, :has_search_individual_right?, :has_search_zone_right?, :has_index_individual_right?, :has_index_zone_right?
    
    def return_yes_no_cn
      [['是',true ],['否', false]]
    end
  
    def has_index_right?(table_name)
      grant_access?('index', table_name)  
    end
    
    def has_index_individual_right?(table_name)
      grant_access?('index_individual', table_name)
    end
    
    def has_index_zone_right?(table_name)
      grant_access?('index_zone', table_name)
    end
    
    def has_show_right?(table_name)
      grant_access?('show', table_name)  
    end
    
    def has_create_right?(table_name)
      grant_access?('create', table_name)  
    end
    
    def has_update_right?(table_name)
      grant_access?('update', table_name)  
    end
    
    def has_destroy_right?(table_name)
      grant_access?('destroy', table_name)
    end
    
    def has_search_right?(table_name)
      grant_access?('search', table_name)
    end
    
    def has_search_individual_right?(table_name)
      grant_access?('search_individual', table_name)
    end
    
    def has_search_zone_right?(table_name)
      grant_access?('search_zone', table_name)
    end
    
    #allow to activate/deactivate a customer
    def has_activate_right?(table_name)
      grant_access?('activate', table_name)
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
