require 'spec_helper'

module Customerx
  describe SalesLead do
    it "should be OK" do
      l = FactoryGirl.build(:sales_lead)
      pp l
      l.should be_valid
    end
    
    it "should reject nil customer id" do
      l =  FactoryGirl.build(:sales_lead, :customer_id => nil)
      l.should_not be_valid
    end
    
    it "should reject nil provider_id" do
      l = FactoryGirl.build(:sales_lead, :provider_id => nil)
      l.should_not be_valid
    end
    
    it "should reject nil lead_info" do
      l = FactoryGirl.build(:sales_lead, :lead_info => nil)
      l.should_not be_valid
    end
    
    it "should reject nil contact_instructino" do
      l = FactoryGirl.build(:sales_lead, :contact_instruction => nil)
      l.should_not be_valid
    end
    
  end
end
