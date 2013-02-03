module Customerx
  class CommRecordLog < ActiveRecord::Base

    attr_accessible :last_updated_by_id, :log, :customer_comm_record_id, :void, :as => :role_new
    belongs_to :customer_comm_record, :class_name => "Customerx::CustomerCommRecord"
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    
    validates :log, :presence => true, :uniqueness => {:case_sensitive => false}
    validates_presence_of :customer_comm_record_id
  end
end
