module Customerx
  class LeadSource < ActiveRecord::Base
    attr_accessible :active, :name, :ranking_order, :last_updated_by_id, :brief_note, :as => :role_new
    attr_accessible :active, :name, :ranking_order, :brief_note, :as => :role_update
    
    has_many :sales_leads, :class_name => 'Customerx::SalesLead'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    
    validates_presence_of :name
    
    scope :active, where(:active => true)
  end
end
