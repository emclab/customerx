require 'spec_helper'

module Customerx
  describe Log do
    it "should be OK" do
      l = FactoryGirl.build(:log)
      l.should be_valid  
    end
    
    it "should reject nil log" do
      l = FactoryGirl.build(:log, :log => nil)
      l.should_not be_valid
    end
    
    it "should reject if both sales_lead_id and customer_comm_record_id present" do
      l = FactoryGirl.build(:log, :sales_lead_id => 1, :customer_comm_record_id => 2)
      l.should_not be_valid
    end
    
    it "should reject both nil customer_comm_record_id and sales_lead_id" do
      l = FactoryGirl.build(:log, :customer_comm_record_id => nil, :sales_lead_id => nil)
      l.should_not be_valid
    end
    
    it "should reject nil which_table" do
      l = FactoryGirl.build(:log, :which_table => nil)
      l.should_not be_valid
    end
    
    it "should reject duplicate log" do
      l1 = FactoryGirl.create(:log, :log => 'this is a new log')
      l2 = FactoryGirl.build(:log, :log => 'This Is A New Log')
      l2.should_not be_valid
    end    
  end
end
