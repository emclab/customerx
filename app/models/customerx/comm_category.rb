module Customerx
  class CommCategory < ActiveRecord::Base
    has_many :customer_comm_records, :class_name => "Customerx::CustomerCommRecord"
    belongs_to :last_updated_by, :class_name => "Authentify::User"
    
    attr_accessible :active, :brief_note, :last_updated_by_id, :name, :ranking_order, :as => :role_new   
    attr_accessible :active, :brief_note, :name, :ranking_order, :as => :role_update
    
    validates :name, :presence => true,
                     :uniqueness => {:case_sensitive => false, :message => 'Duplicate customer communication category' }   
  end
end
