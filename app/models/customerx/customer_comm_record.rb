module Customerx
  class CustomerCommRecord < ActiveRecord::Base
    
    attr_accessor :customer_name, :void_name, :reported_by_name, :via_noupdate     #for readonly field
    attr_accessible :comm_category_id, :comm_date, :contact_info, :content, :customer_id, :last_updated_by_id, :reported_by_id, 
                    :subject, :via, :customer_name_autocomplete, :as => :role_new
    attr_accessible :comm_category_id, :comm_date, :contact_info, :content, :customer_id, :last_updated_by_id, :reported_by_id, 
                    :subject, :via, :void, :as => :role_update  
                    
    attr_accessor :customer_id_s, :start_date_s, :end_date_s, :zone_id_s, :sales_id_s, :comm_category_id_s, :via_s
    attr_accessible :customer_id_s, :start_date_s, :end_date_s,:zone_id_s, :sales_id_s, :comm_category_id_s, :via_s,
                    :as => :role_search_stats
                    
    belongs_to :customer, :class_name => 'Customerx::Customer'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'    
    belongs_to :comm_category, :class_name => 'Commonx::MiscDefinition' 
    belongs_to :reported_by, :class_name => 'Authentify::User'   
    has_many :logs, :class_name => "Customerx::Log" 
    
    validates_presence_of :subject, :contact_info, :content, :reported_by_id, :via, :comm_category_id, :comm_date, :customer_id
    validates :content, :uniqueness => {:case_sensitive => false}  
    
    def find_customer_comm_records
      records = Customerx::CustomerCommRecord.where('comm_date > ?', 6.years.ago).order('comm_date DESC')
    end
    
    def customer_name_autocomplete
      self.customer.try(:name)
    end

    def customer_name_autocomplete=(name)
      self.customer = Customerx::Customer.find_by_name(name) if name.present?
    end
    
    scope :not_void, where(:void => false)
    
    def find_customer_comm_records
      #return 6 years qualified records
      records = Customerx::CustomerCommRecord.where("comm_date > ?", 6.years.ago)
      records = records.where('comm_date > ?', start_date_s) if start_date_s.present?
      records = records.where('comm_date < ?', end_date_s) if end_date_s.present?
      if zone_id_s.present?
        records = records.where(:customer_id => Customerx::Customer.where(:zone_id => zone_id_s).select("customer_id")) 
      end
      if sales_id_s.present?
        records = records.where(:customer_id => Customerx::Customer.where(:sales_id => sales_id_s).select("customer_id")) 
      end
      records = records.where(:comm_category_id => comm_category_id_s) if comm_category_id_s.present?
      records = records.where("customer_id = ?", customer_id_s) if customer_id_s.present?
      records
    end
           
    protected
    
  end
end
