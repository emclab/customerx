module Customerx
  class QualitySystem < ActiveRecord::Base
    
    has_many :customers, :class_name => "Customerx::Customer"
    belongs_to :last_updated_by, :class_name => "Authentify::User"
    
    attr_accessible :active, :brief_note, :last_updated_by_id, :name, :ranking_order, :as => :role_new   #active, last_updated_by_id for rspec ONLY.
    attr_accessible :active, :brief_note, :name, :ranking_order, :as => :role_update
    
    validates :name, :presence => true,
                     :uniqueness => {:case_sensitive => false, :message => 'Duplicate quality system' }    
  end
end
