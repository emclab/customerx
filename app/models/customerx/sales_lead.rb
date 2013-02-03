module Customerx
  class SalesLead < ActiveRecord::Base
    
    attr_accessor :customer_name
    
    attr_accessible :lead_eval, :contact_instruction, :customer_id, :last_updated_by_id, :lead_accuracy, :lead_quality, 
                    :lead_info, :sales_success, :lead_source_id, :lead_status, :provider_id, :subject, :lead_date, :as => :role_new
    attr_accessible :lead_eval, :contact_instruction, :last_updated_by_id, :lead_accuracy, :lead_quality, :close_lead, :lead_date,
                    :close_lead_date, :close_lead_by_id, :lead_info, :sales_success, :lead_source_id, :provider_id, :subject,
                    :as => :role_update 
                    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :provider, :class_name => 'Authentify::User'
    belongs_to :close_lead_by, :class_name => 'Authentify::User'
    has_many :lead_logs, :class_name => "Customerx::LeadLog"
    belongs_to :customer, :class_name => 'Customerx::Customer'
    belongs_to :lead_source, :class_name => 'Customerx::LeadSource'
    
    validates_presence_of :customer_id, :provider_id, :lead_info, :subject, :lead_date
    
    def find_sales_leads
      sales_leads = Customerx::SalesLead.where("created_at < ?", 6.years.ago)
      sales_leads
    end
    
    def customer_name_autocomplete
      self.customer.try(:name)
    end

    def customer_name_autocomplete=(name)
      self.customer = Customerx::Customer.find_by_name(name) if name.present?
    end
                   
  end
end
