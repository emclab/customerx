module Customerx
  class CustomerStatusCategory < ActiveRecord::Base
    has_many :customers, :class_name => "Customerx::Customer"
    belongs_to :last_updated_by, :class_name => "Authentify::User"
    
    attr_accessible :brief_note, :cate_name, :ranking_order, :active, :last_updated_by_id, :as => :role_new   #active, last_updated_by_id for rspec ONLY.
    attr_accessible :active, :brief_note, :cate_name, :ranking_order, :as => :role_update
    
    validates :cate_name, :presence => true,
                          :uniqueness => {:case_sensitive => false, :message => 'Duplicate category name' }
  end
end
