module Customerx
  class CustomerCommRecord < ActiveRecord::Base
    
    attr_accessor :customer_name
    attr_accessible :comm_category_id, :comm_date, :contact_info, :content, :customer_id, :last_updated_by_id, :reported_by_id, 
                    :subject, :via, :customer_name_autocomplete, :as => :role_new
    attr_accessible :comm_category_id, :comm_date, :contact_info, :content, :customer_id, :last_updated_by_id, :reported_by_id, 
                    :subject, :via, :as => :role_update  
    belongs_to :customer, :class_name => 'Customerx::Customer'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'    
    belongs_to :comm_category, :class_name => 'Customerx::CommCategory' 
    belongs_to :reported_by, :class_name => 'Authentify::User'   
    has_many :comm_record_logs, :class_name => "Customerx::CommRecordLog" 
    
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
  end
end
