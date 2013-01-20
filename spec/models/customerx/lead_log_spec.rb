require 'spec_helper'

module Customerx
  describe LeadLog do
    
    it "should be OK" do
      l = FactoryGirl.build(:lead_log)
      l.should be_valid  
    end
    
    it "should reject nil log" do
      l = FactoryGirl.build(:lead_log, :log => nil)
      l.should_not be_valid
    end
    
    it "should reject nil sales_lead" do
      l = FactoryGirl.build(:lead_log, :sales_lead_id => nil)
      l.should_not be_valid
    end
  end
end
