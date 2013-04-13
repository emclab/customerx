module Customerx
  class MiscDefinition < ActiveRecord::Base
    attr_accessor :active_noupdate
    attr_accessible :brief_note, :last_updated_by_id, :name, :ranking_order, :for_which, :as => :role_new   
    attr_accessible :active, :brief_note, :name, :ranking_order, :for_which, :as => :role_update
    
    has_many :customers, :class_name => "Customerx::Customer"   
    has_many :customer_comm_records, :class_name => "Customerx::CustomerCommRecord"
    belongs_to :last_updated_by, :class_name => "Authentify::User"
        
    validates :for_which, :presence => true  
    validates :name, :presence => true,
                     :uniqueness => {:scope => :for_which, :case_sensitive => false, :message => 'Duplicate entry' }   
  end
end
