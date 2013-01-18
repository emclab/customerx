module Customerx
  module CustomersHelper
    def return_quality_system
      Customerx::QualitySystem.where("active = ?", true).order("ranking_order")
    end
    
    def return_customer_status_category
      Customerx::CustomerStatusCategory.where("active = ?", true).order("ranking_order")  
    end    
  end
end
