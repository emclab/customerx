require 'spec_helper'

module Customerx
  describe CommRecordLog do
    it "should be OK" do
      l = FactoryGirl.build(:comm_record_log)
      l.should be_valid  
    end
    
    it "should reject nil log" do
      l = FactoryGirl.build(:comm_record_log, :log => nil)
      l.should_not be_valid
    end
    
    it "should reject nil comm record" do
      l = FactoryGirl.build(:comm_record_log, :customer_comm_record_id => nil)
      l.should_not be_valid
    end
    
    it "should reject duplicate log" do
      l1 = FactoryGirl.create(:comm_record_log, :log => 'this is a new log')
      l2 = FactoryGirl.build(:comm_record_log, :log => 'This Is A New Log')
      l2.should_not be_valid
    end    
  end
end
