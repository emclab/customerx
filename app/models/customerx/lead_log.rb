module Customerx
  class LeadLog < ActiveRecord::Base
    attr_accessible :last_updated_by_id, :log, :sales_lead_id, :as => :role_new
    belongs_to :sales_lead, :class_name => 'Customerx::SalesLead'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    
    validates_presence_of :log, :sales_lead_id
  end
end
