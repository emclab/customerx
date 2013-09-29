module Customerx
  module CustomerxHelper
    
    def return_customers_by_access_right
      access_rights, model_ar_r, has_record_access = access_right_finder('index', 'customerx/customers')
      return [] if access_rights.blank?
      return model_ar_r 
    end
   
    def return_quality_system
      Commonx::MiscDefinition.where(:for_which => 'quality_system').where("active = ?", true).order("ranking_index")
    end
    
    def return_customer_status_category
      Commonx::MiscDefinition.where(:for_which => 'customer_status').where("active = ?", true).order("ranking_index")  
    end 

  end
end
