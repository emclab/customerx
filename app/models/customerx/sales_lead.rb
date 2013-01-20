module Customerx
  class SalesLead < ActiveRecord::Base
    
    attr_accessible :lead_eval, :contact_instruction, :customer_id, :last_updated_by_id, :lead_accuracy, :lead_quality, 
                    :lead_info, :sales_success, :lead_source, :lead_status, :provider_id, :as => :role_new
    attr_accessible :lead_eval, :contact_instruction, :last_updated_by_id, :lead_accuracy, :lead_quality, :close_lead, 
                    :close_lead_date, :close_lead_by_id, :lead_info, :sales_success, :lead_source, :provider_id, 
                    :as => :role_update 
                    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :provider, :class_name => 'Authentify::User'
    belongs_to :close_lead_by, :class_name => 'Authentify::User'
    has_many :lead_logs
    belongs_to :customer, :class_name => 'Customerx::Customer'
    
    validates_presence_of :customer_id, :provider_id, :lead_info, :contact_instruction
    
    def find_sales_leads
      sales_leads = Customerx::SalesLead.where("created_at < ?", 6.years.ago)
      sales_leads
    end
                   
  end
end
