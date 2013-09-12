module Customerx
  class SalesLead < ActiveRecord::Base
    
    attr_accessor :customer_name, :lead_source_name, :sale_success_value, :close_lead_value
    
    attr_accessible :lead_eval, :contact_instruction, :customer_id, :last_updated_by_id, :lead_accuracy, :lead_quality, 
                    :lead_info, :sale_success, :lead_source_id, :lead_status, :provider_id, :subject, :lead_date, :provider_name_autocomplete,
                    :customer_name_autocomplete, :initial_order_total,
                    :customer_name, :lead_source_name, :sale_success_value, :close_lead_value,
                    :as => :role_new
    attr_accessible :lead_eval, :contact_instruction, :last_updated_by_id, :lead_accuracy, :lead_quality, :close_lead, :lead_date,
                    :close_lead_date, :close_lead_by_id, :lead_info, :sale_success, :lead_source_id, :provider_id, :subject,
                    :provider_name_autocomplete, :customer_name_autocomplete, :customer_name, :initial_order_total,
                    :customer_name, :lead_source_name, :sale_success_value, :close_lead_value,
                    :as => :role_update 
                    
    attr_accessor :customer_id_s, :start_date_s, :end_date_s, :zone_id_s, :sales_id_s, :lead_source_id_s
    attr_accessible :customer_id_s, :start_date_s, :end_date_s,:zone_id_s, :sales_id_s, :lead_source_id_s, 
                    :as => :role_search_stats                
                    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :provider, :class_name => 'Authentify::User'
    belongs_to :close_lead_by, :class_name => 'Authentify::User'
    has_many :logs, :class_name => "Customerx::Log"
    belongs_to :customer, :class_name => 'Customerx::Customer'
    belongs_to :lead_source, :class_name => 'Commonx::MiscDefinition'
    
    validates_presence_of :customer_id, :provider_id, :lead_info, :subject, :lead_date, :lead_source_id
    validates :lead_info, :uniqueness => {:case_sensitive => false}
    
    def find_sales_leads
      sales_leads = Customerx::SalesLead.where("customerx_sales_leads.created_at > ?", 6.years.ago)
      sales_leads
    end
    
    def customer_name_autocomplete
      self.customer.try(:name)
    end

    def customer_name_autocomplete=(name)
      self.customer = Customerx::Customer.find_by_name(name) if name.present?
    end
    
    def provider_name_autocomplete
      self.provider.try(:name)
    end

    def provider_name_autocomplete=(name)
      self.provider = Authentify::User.find_by_name(name) if name.present?
    end
    
    def find_sales_leads
      #return 6 years qualified records
      records = Customerx::SalesLead.where("lead_date > ?", 6.years.ago)
      records = records.where('lead_date > ?', start_date_s) if start_date_s.present?
      records = records.where('lead_date < ?', end_date_s) if end_date_s.present?
      if zone_id_s.present?
        records = records.where(:customer_id => Customerx::Customer.where(:zone_id => zone_id_s).select("customer_id")) 
      end
      if sales_id_s.present?
        records = records.where(:customer_id => Customerx::Customer.where(:sales_id => sales_id_s).select("customer_id")) 
      end
      records = records.where(:lead_source_id => lead_source_id_s) if lead_source_id_s.present?
      records = records.where("customer_id = ?", customer_id_s) if customer_id_s.present?
      records
    end
                   
  end
end
