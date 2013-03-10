# encoding: utf-8
module Customerx
  class Log < ActiveRecord::Base
    attr_accessible :customer_comm_record_id, :last_updated_by_id, :log, :sales_lead_id, :log, :which_table, :as => :role_new
    belongs_to :sales_lead, :class_name => 'Customerx::SalesLead'
    belongs_to :customer_comm_record, :class_name => 'Customerx::CustomerCommRecord'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    
    validates :log, :presence => true, :uniqueness => {:scope => :which_table, :case_sensitive => false}
    validates :which_table, :presence => true
    validates :sales_lead_id, :presence => true, :if => "customer_comm_record_id.nil?"
    validates :customer_comm_record_id, :presence => true, :if => 'sales_lead_id.nil?'
    validate :ids_not_be_present_at_same_time
    
    private
    def ids_not_be_present_at_same_time
      if customer_comm_record_id.present? && sales_lead_id.present?
        errors.add(:sales_lead_id, "Missing parental object!")
      end   
    end
  end
end
